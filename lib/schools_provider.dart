import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:necta_test3/classes/school_model.dart';
import 'package:necta_test3/file_processor.dart';
import 'package:necta_test3/hive/processed_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'schools_provider.g.dart';

@riverpod
class Schools extends _$Schools {
  @override
  Future<List<School>> build() async {
    final fileProcessor = ref.watch(fileProcessorProvider.notifier);

    try {
      if (!Hive.isBoxOpen('processed_data')) {
        await fileProcessor.initHive();
      }

      final storedData = await fileProcessor.getStoredData();

      if (storedData == null) {
        const String zipPath = 'gs://necta-test1-81f48.appspot.com/csee/2023/2023.zip';
        final processedData = await fileProcessor.processAllFiles(zipPath);

        return processedData.schools.map((schoolData) {
          try {
            return School.fromJson(schoolData);
          } catch (e) {
            print('Error converting school data: $e');
            throw Exception('Failed to convert school data: $e');
          }
        }).toList();
      }

      return storedData.schools.map((schoolData) {
        try {
          return School.fromJson(schoolData);
        } catch (e) {
          print('Error converting stored school data: $e');
          throw Exception('Failed to convert stored school data: $e');
        }
      }).toList();
    } catch (e) {
      print('Error loading schools data: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

@riverpod
Future<List<School>> filteredSchools(FilteredSchoolsRef ref, {String? searchQuery}) async {
  final schoolsAsync = await ref.watch(schoolsProvider.future);

  if (searchQuery == null || searchQuery.isEmpty) {
    return schoolsAsync;
  }

  final query = searchQuery.toLowerCase();
  return schoolsAsync.where((school) {
    return school.school.name.toLowerCase().contains(query) || school.school.region.toLowerCase().contains(query) || school.school.id.toLowerCase().contains(query);
  }).toList();
}

@riverpod
Future<Map<String, dynamic>> schoolStats(SchoolStatsRef ref) async {
  final schools = await ref.watch(schoolsProvider.future);

  if (schools.isEmpty) {
    return {
      'totalSchools': 0,
      'averageGPA': 0.0,
      'totalStudents': 0,
    };
  }

  double totalGPA = 0;
  int totalStudents = 0;

  for (final school in schools) {
    totalGPA += double.tryParse(school.school.gpa) ?? 0;
    totalStudents += int.tryParse(school.students.first.registered) ?? 0;
  }

  return {
    'totalSchools': schools.length,
    'averageGPA': schools.isEmpty ? 0 : totalGPA / schools.length,
    'totalStudents': totalStudents,
  };
}

class SchoolsList extends ConsumerWidget {
  const SchoolsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolsAsync = ref.watch(schoolsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schools'),
      ),
      body: schoolsAsync.when(
        data: (schools) => ListView.builder(
          itemCount: schools.length,
          itemBuilder: (context, index) {
            final school = schools[index];

            return ListTile(
              title: Text(school.school.name),
              subtitle: Text('GPA: ${school.school.id}'),
              onTap: () {
                print(schools.length);
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading schools: $error'),
        ),
      ),
    );
  }
}
