import 'package:necta_test3/classes/school_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:developer' as developer;

part 'sqdb_repository.g.dart';

class SqdbRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'schools.db');

    developer.log('Initializing database at path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        developer.log('Creating new database schema version $version');

        // Schools table
        await db.execute('''
          CREATE TABLE schools (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            url TEXT,
            region TEXT,
            passed TEXT,
            gpa TEXT,
            grade TEXT
          )
        ''');
        developer.log('Created schools table');

        // Student stats table
        await db.execute('''
          CREATE TABLE student_stats (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            school_id TEXT,
            registered TEXT,
            absent TEXT,
            sat TEXT,
            withheld TEXT,
            noca TEXT,
            clean TEXT,
            FOREIGN KEY (school_id) REFERENCES schools (id)
          )
        ''');
        developer.log('Created student_stats table');

        // Divisions table
        await db.execute('''
          CREATE TABLE divisions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            school_id TEXT,
            type TEXT,
            div_i INTEGER,
            div_ii INTEGER,
            div_iii INTEGER,
            div_iv INTEGER,
            div_0 INTEGER,
            FOREIGN KEY (school_id) REFERENCES schools (id)
          )
        ''');
        developer.log('Created divisions table');

        // Centers table
        await db.execute('''
          CREATE TABLE centers (
            code TEXT PRIMARY KEY,
            school_id TEXT,
            name TEXT,
            registered TEXT,
            sat TEXT,
            noca TEXT,
            withheld TEXT,
            clean TEXT,
            pass TEXT,
            gpa TEXT,
            grade TEXT,
            FOREIGN KEY (school_id) REFERENCES schools (id)
          )
        ''');
        developer.log('Created centers table');

        // Student results table
        await db.execute('''
          CREATE TABLE student_results (
            student_id TEXT PRIMARY KEY,
            school_id TEXT,
            sex TEXT,
            aggregate TEXT,
            division TEXT,
            FOREIGN KEY (school_id) REFERENCES schools (id)
          )
        ''');
        developer.log('Created student_results table');

        // Subjects table
        await db.execute('''
          CREATE TABLE subjects (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            student_id TEXT,
            code TEXT,
            grade TEXT,
            FOREIGN KEY (student_id) REFERENCES student_results (student_id)
          )
        ''');
        developer.log('Created subjects table');

        // Create FTS virtual table using FTS4
        await db.execute('''
          CREATE VIRTUAL TABLE schools_fts USING fts4(
            name,
            region,
            content='schools'
          )
        ''');
        developer.log('Created schools_fts virtual table');

        // Create triggers to keep FTS table in sync
        await db.execute('''
          CREATE TRIGGER schools_after_insert AFTER INSERT ON schools BEGIN
            INSERT INTO schools_fts(docid, name, region)
            VALUES (new.rowid, new.name, new.region);
          END
        ''');

        await db.execute('''
          CREATE TRIGGER schools_after_delete AFTER DELETE ON schools BEGIN
            DELETE FROM schools_fts WHERE docid = old.rowid;
          END
        ''');

        await db.execute('''
          CREATE TRIGGER schools_after_update AFTER UPDATE ON schools BEGIN
            DELETE FROM schools_fts WHERE docid = old.rowid;
            INSERT INTO schools_fts(docid, name, region)
            VALUES (new.rowid, new.name, new.region);
          END
        ''');
        developer.log('Created FTS triggers');
      },
      onOpen: (db) {
        developer.log('Database opened successfully');
      },
    );
  }

  Future<void> insertSchool(School school) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        developer.log('Starting transaction for school: ${school.school.name}');

        // Insert school info
        await txn.insert(
          'schools',
          {
            'id': school.school.id,
            'name': school.school.name,
            'url': school.school.url,
            'region': school.school.region,
            'passed': school.school.passed,
            'gpa': school.school.gpa,
            'grade': school.school.grade,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        developer.log('Inserted basic school info for: ${school.school.name}');

        // Insert student stats
        for (var stats in school.students) {
          await txn.insert(
            'student_stats',
            {
              'school_id': school.school.id,
              'registered': stats.registered,
              'absent': stats.absent,
              'sat': stats.sat,
              'withheld': stats.withheld,
              'noca': stats.noca,
              'clean': stats.clean,
            },
          );
        }
        developer.log('Inserted ${school.students.length} student stats records');

        // Insert female divisions
        await txn.insert('divisions', {
          'school_id': school.school.id,
          'type': 'female',
          'div_i': school.divisions.female.divI,
          'div_ii': school.divisions.female.divII,
          'div_iii': school.divisions.female.divIII,
          'div_iv': school.divisions.female.divIV,
          'div_0': school.divisions.female.div0,
        });

        // Insert male divisions
        await txn.insert('divisions', {
          'school_id': school.school.id,
          'type': 'male',
          'div_i': school.divisions.male.divI,
          'div_ii': school.divisions.male.divII,
          'div_iii': school.divisions.male.divIII,
          'div_iv': school.divisions.male.divIV,
          'div_0': school.divisions.male.div0,
        });
        developer.log('Inserted division records for both genders');

        // Insert centers
        for (var center in school.centre) {
          await txn.insert(
            'centers',
            {
              'code': center.code,
              'school_id': school.school.id,
              'name': center.name,
              'registered': center.registered,
              'sat': center.sat,
              'noca': center.noca,
              'withheld': center.withheld,
              'clean': center.clean,
              'pass': center.pass,
              'gpa': center.gpa,
              'grade': center.grade,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        developer.log('Inserted ${school.centre.length} center records');

        // Insert student results and subjects
        var subjectCount = 0;
        for (var result in school.results) {
          await txn.insert(
            'student_results',
            {
              'student_id': result.studentId,
              'school_id': school.school.id,
              'sex': result.sex,
              'aggregate': result.aggregate,
              'division': result.division,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );

          for (var subject in result.subjects) {
            await txn.insert(
              'subjects',
              {
                'student_id': result.studentId,
                'code': subject.code,
                'grade': subject.grade,
              },
            );
            subjectCount++;
          }
        }
        developer.log('Inserted ${school.results.length} student results with $subjectCount subjects');
      });
      developer.log('Successfully completed all insertions for school: ${school.school.name}');
    } catch (e, stackTrace) {
      developer.log(
        'Error inserting school data',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<School?> getSchoolById(String id) async {
    final db = await database;
    try {
      developer.log('Fetching school with ID: $id');
      final schoolData = await db.query('schools', where: 'id = ?', whereArgs: [id]);

      if (schoolData.isEmpty) {
        developer.log('No school found with ID: $id');
        return null;
      }

      final students = await db.query('student_stats', where: 'school_id = ?', whereArgs: [id]);
      final divisions = await db.query('divisions', where: 'school_id = ?', whereArgs: [id]);
      final centres = await db.query('centers', where: 'school_id = ?', whereArgs: [id]);
      final results = await db.query('student_results', where: 'school_id = ?', whereArgs: [id]);

      developer.log('Found for school $id: ${students.length} stats, ${divisions.length} divisions, '
          '${centres.length} centres, ${results.length} results');

      // Fetch subjects for each student
      final List<Map<String, dynamic>> completeResults = [];
      for (var result in results) {
        final subjects = await db.query(
          'subjects',
          where: 'student_id = ?',
          whereArgs: [result['student_id']],
        );

        completeResults.add({
          ...result,
          'subjects': subjects,
        });
      }

      // TODO: Implement the conversion from raw data to School model
      // This would depend on your School model structure
      return null;
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching school by ID',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> searchSchools(String query) async {
    final db = await database;
    try {
      developer.log('Searching schools with query: "$query"');
      final results = await db.rawQuery('''
        SELECT schools.* 
        FROM schools
        JOIN schools_fts ON schools.rowid = schools_fts.docid
        WHERE schools_fts MATCH ?
        LIMIT 50
      ''', ['${query}*']);

      developer.log('Search returned ${results.length} results');
      return results;
    } catch (e, stackTrace) {
      developer.log(
        'Error searching schools',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<bool> isDatabaseEmpty() async {
    final db = await database;
    try {
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM schools');
      final count = Sqflite.firstIntValue(result);
      developer.log('Current number of schools in database: $count');
      return count == 0;
    } catch (e, stackTrace) {
      developer.log(
        'Error checking if database is empty',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> deleteDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'schools.db');
      await databaseFactory.deleteDatabase(path);
      _database = null;
      developer.log('Database deleted successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error deleting database',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDatabaseStats() async {
    final db = await database;
    try {
      final schoolCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM schools'));
      final studentStatsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM student_stats'));
      final divisionsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM divisions'));
      final centersCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM centers'));
      final resultsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM student_results'));
      final subjectsCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM subjects'));

      return {
        'schools': schoolCount,
        'student_stats': studentStatsCount,
        'divisions': divisionsCount,
        'centers': centersCount,
        'student_results': resultsCount,
        'subjects': subjectsCount,
      };
    } catch (e, stackTrace) {
      developer.log(
        'Error getting database stats',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}

@riverpod
SqdbRepository sqdbRepository(SqdbRepositoryRef ref) {
  return SqdbRepository();
}
