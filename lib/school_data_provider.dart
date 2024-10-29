import 'package:flutter/foundation.dart';
import 'package:necta_test3/classes/school_model.dart';
import 'package:necta_test3/firebase_repository.dart';
import 'package:necta_test3/storage_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'school_data_provider.g.dart';

@riverpod
class SchoolDataCache extends _$SchoolDataCache {
  List<School>? _cachedSchools;

  @override
  List<School>? build() => _cachedSchools;

  void updateCache(List<School> schools) {
    _cachedSchools = schools;
    state = schools;
  }

  void clearCache() {
    _cachedSchools = null;
    state = null;
  }
}

@riverpod
class SchoolDataManager extends _$SchoolDataManager {
  static const String zipPath = 'gs://necta-test1-81f48.appspot.com/csee/2023.zip';

  bool _isInitializing = false;
  bool _storageInitialized = false;

  @override
  Future<List<School>> build() async {
    final cache = ref.watch(schoolDataCacheProvider);
    if (cache != null) return cache;

    return _loadData();
  }

  Future<void> _ensureStorageInitialized() async {
    if (!_storageInitialized) {
      final start = DateTime.now();
      print('Initializing local storage started at: $start');

      final storageRepo = ref.read(storageRepositoryProvider);
      await storageRepo.initializeStorage();

      final end = DateTime.now();
      print('Finished initializing local storage at: $end');
      print('Time taken to initialize storage: ${end.difference(start).inSeconds} seconds');

      _storageInitialized = true;
    }
  }

  Future<List<School>> _loadData() async {
    if (_isInitializing) {
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final cache = ref.read(schoolDataCacheProvider);
      if (cache != null) return cache;
    }

    _isInitializing = true;
    try {
      // Ensure storage is initialized first
      await _ensureStorageInitialized();

      final storageRepo = ref.read(storageRepositoryProvider);
      final firebaseRepo = ref.read(firebaseRepositoryProvider);

      // Try to get data from local storage
      final startLocalFetch = DateTime.now();
      print('Fetching school data from local storage started at: $startLocalFetch');

      final storedData = await storageRepo.getSchoolData();

      final endLocalFetch = DateTime.now();
      print('Finished fetching school data from local storage at: $endLocalFetch');
      print('Time taken to fetch school data from local storage: ${endLocalFetch.difference(startLocalFetch).inSeconds} seconds');

      if (storedData != null) {
        final startConvert = DateTime.now();
        print('Converting stored data to schools started at: $startConvert');

        final schools = await compute(_convertToSchools, storedData.schools);

        final endConvert = DateTime.now();
        print('Finished converting stored data at: $endConvert');
        print('Time taken to convert stored data: ${endConvert.difference(startConvert).inSeconds} seconds');

        ref.read(schoolDataCacheProvider.notifier).updateCache(schools);
        return schools;
      }

      // Fetch from Firebase and process
      final startFirebaseFetch = DateTime.now();
      print('Fetching school data from Firebase started at: $startFirebaseFetch');

      final processedData = await firebaseRepo.fetchAndProcessSchoolData(zipPath);

      final endFirebaseFetch = DateTime.now();
      print('Finished fetching school data from Firebase at: $endFirebaseFetch');
      print('Time taken to fetch and process data from Firebase: ${endFirebaseFetch.difference(startFirebaseFetch).inSeconds} seconds');

      // Save to storage and convert to schools in parallel
      final startSave = DateTime.now();
      print('Saving processed data to local storage started at: $startSave');

      final saveFuture = storageRepo.saveSchoolData(processedData);

      final startConvertFirebase = DateTime.now();
      print('Converting Firebase data to schools started at: $startConvertFirebase');

      final schools = await compute(_convertToSchools, processedData.schools);

      final endConvertFirebase = DateTime.now();
      print('Finished converting Firebase data at: $endConvertFirebase');
      print('Time taken to convert Firebase data: ${endConvertFirebase.difference(startConvertFirebase).inSeconds} seconds');

      // Wait for save to complete
      await saveFuture;

      final endSave = DateTime.now();
      print('Finished saving processed data to local storage at: $endSave');
      print('Time taken to save processed data: ${endSave.difference(startSave).inSeconds} seconds');

      ref.read(schoolDataCacheProvider.notifier).updateCache(schools);
      return schools;
    } catch (e) {
      print('Error loading schools data: $e');
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  static List<School> _convertToSchools(List<Map<String, dynamic>> schoolsData) {
    return schoolsData.map((schoolData) {
      try {
        return School.fromJson(schoolData);
      } catch (e) {
        print('Error converting school data: $e');
        throw Exception('Failed to convert school data: $e');
      }
    }).toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    ref.read(schoolDataCacheProvider.notifier).clearCache();

    try {
      final schools = await _loadData();
      state = AsyncValue.data(schools);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> clearCache() async {
    await _ensureStorageInitialized();
    final storageRepo = ref.read(storageRepositoryProvider);
    await storageRepo.clearSchoolData();
    ref.read(schoolDataCacheProvider.notifier).clearCache();
  }
}
