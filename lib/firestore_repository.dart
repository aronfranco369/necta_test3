// Updated fire_repository.dart with improved error handling and logging

import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:necta_test3/classes/school_model.dart';
import 'package:necta_test3/sqlite/sqdb_repository.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_repository.g.dart';

class FireRepository {
  final _storage = FirebaseStorage.instance;

  Future<List<School>> fetchAndProcessSchoolData(String zipPath) async {
    print('Starting fetchAndProcessSchoolData...');
    final extractedData = await _downloadAndExtractZip(zipPath);
    print('Zip extracted to: ${extractedData.path}');
    return _processExtractedData(extractedData);
  }

  Future<Directory> _downloadAndExtractZip(String zipPath) async {
    print('Starting zip download from: $zipPath');
    final appDir = await getApplicationDocumentsDirectory();
    final zipFile = File(path.join(appDir.path, '2023.zip'));

    try {
      await _storage.refFromURL(zipPath).writeToFile(zipFile);
      print('Zip file downloaded successfully. Size: ${await zipFile.length()} bytes');
    } catch (e) {
      print('Error downloading zip file: $e');
      rethrow;
    }

    try {
      final bytes = await zipFile.readAsBytes();
      print('Read zip file bytes: ${bytes.length}');

      final outputDir = Directory(path.join(appDir.path, '2023unzipped'))..createSync(recursive: true);
      print('Created output directory: ${outputDir.path}');

      final archive = ZipDecoder().decodeBytes(bytes);
      print('Zip archive decoded. Found ${archive.length} files');

      for (final file in archive) {
        if (file.isFile) {
          final outputFile = File(path.join(outputDir.path, file.name));
          outputFile.createSync(recursive: true);
          outputFile.writeAsBytesSync(file.content as List<int>);
          print('Extracted: ${file.name} (${file.content.length} bytes)');
        }
      }

      return outputDir;
    } catch (e) {
      print('Error extracting zip file: $e');
      rethrow;
    }
  }

  Future<List<School>> _processExtractedData(Directory outputDir) async {
    List<School> schools = [];
    print('Starting to process extracted data from: ${outputDir.path}');

    try {
      await for (final entity in outputDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.xz')) {
          print('Processing XZ file: ${entity.path}');

          try {
            final compressedBytes = await entity.readAsBytes();
            print('Read compressed bytes: ${compressedBytes.length}');

            final decompressed = XZDecoder().decodeBytes(compressedBytes);
            print('Decompressed size: ${decompressed.length} bytes');

            final jsonString = utf8.decode(decompressed);
            print('Decoded JSON string length: ${jsonString.length}');

            // Print a sample of the JSON for debugging
            final jsonSample = jsonString.substring(0, min(500, jsonString.length));
            print('JSON sample: $jsonSample');

            final jsonData = json.decode(jsonString);
            print('JSON data type: ${jsonData.runtimeType}');

            if (jsonData is List) {
              print('Processing ${jsonData.length} schools from JSON array');

              for (var i = 0; i < jsonData.length; i++) {
                try {
                  final schoolJson = jsonData[i];
                  print('Processing school ${i + 1}/${jsonData.length}');

                  final school = School.fromJson(schoolJson);
                  schools.add(school);

                  print('Successfully processed school: ${school.school.name}');
                } catch (e, stackTrace) {
                  print('Error processing school at index $i: $e');
                  print('Stack trace: $stackTrace');
                }
              }
            } else {
              print('Warning: Expected JSON array but got ${jsonData.runtimeType}');
            }
          } catch (e, stackTrace) {
            print('Error processing file ${entity.path}: $e');
            print('Stack trace: $stackTrace');
          }
        }
      }

      print('Successfully processed ${schools.length} schools');
      return schools;
    } catch (e, stackTrace) {
      print('Fatal error in _processExtractedData: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

@riverpod
FireRepository fireRepository(FireRepositoryRef ref) {
  return FireRepository();
}

// SchoolsProvider with added logging

@riverpod
class SchoolsProvider extends _$SchoolsProvider {
  @override
  Future<void> build() async {
    state = const AsyncValue.loading();

    try {
      final dbRepo = ref.read(sqdbRepositoryProvider);

      print('Checking if database is empty...');

      if (await dbRepo.isDatabaseEmpty()) {
        print('Database is empty, fetching data from Firebase...');

        final fireRepo = ref.read(fireRepositoryProvider);

        final schools = await fireRepo.fetchAndProcessSchoolData('gs://necta-test1-81f48.appspot.com/csee/2023.zip');

        print('Fetched ${schools.length} schools from Firebase');

        print('Starting database insertion...');

        var count = 0;

        for (final school in schools) {
          await dbRepo.insertSchool(school);

          count++;

          if (count % 100 == 0) {
            print('Inserted $count schools...');
          }
        }

        print('Finished inserting all schools');
      } else {
        print('Database already contains data');
      }

      state = const AsyncValue.data(null);
    } catch (e, st) {
      print('Error in SchoolsProvider: $e');

      print('Stack trace: $st');

      state = AsyncValue.error(e, st);
    }
  }

  Future<List<Map<String, dynamic>>> searchSchools(String query) async {
    final dbRepo = ref.read(sqdbRepositoryProvider);

    try {
      final results = await dbRepo.searchSchools(query);

      print('Search for "$query" returned ${results.length} results');

      return results;
    } catch (e) {
      print('Error searching schools: $e');

      rethrow;
    }
  }
}

// SchoolsScreen widget implementation

class SchoolsScreen extends ConsumerStatefulWidget {
  const SchoolsScreen({super.key});

  @override
  ConsumerState<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends ConsumerState<SchoolsScreen> {
  String searchQuery = '';

  List<Map<String, dynamic>> searchResults = [];

  bool isLoading = false;

  Future<void> performSearch(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await ref.read(schoolsProviderProvider.notifier).searchSchools(query);

      setState(() {
        searchResults = results;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final schoolsState = ref.watch(schoolsProviderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schools'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search schools...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });

                if (value.length >= 2) {
                  performSearch(value);
                }
              },
            ),
          ),
          Expanded(
            child: schoolsState.when(
              data: (_) {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (searchQuery.isEmpty) {
                  return const Center(
                    child: Text('Enter a search term to find schools'),
                  );
                }

                if (searchResults.isEmpty) {
                  return const Center(
                    child: Text('No schools found'),
                  );
                }

                return ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final school = searchResults[index];

                    return ListTile(
                      title: Text(school['name'] ?? ''),
                      subtitle: Text(school['region'] ?? ''),
                      onTap: () {
                        // Handle school selection

                        // Navigate to school details page
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
