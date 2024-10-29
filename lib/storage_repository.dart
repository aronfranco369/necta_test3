import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:necta_test3/hive/processed_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_repository.g.dart';

class LocalStorageRepository {
  static const String boxName = 'school_data';

  Future<void> initializeStorage() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProcessedDataAdapter());
    }

    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<ProcessedData>(boxName);
    }
  }

  Future<void> saveSchoolData(ProcessedData data) async {
    final box = Hive.box<ProcessedData>(boxName);

    await box.clear();
    await box.add(data);
  }

  Future<ProcessedData?> getSchoolData() async {
    final startTime = DateTime.now();
    print('Start fetching school data from local storage at: $startTime');

    final box = Hive.box<ProcessedData>(boxName);
    final ProcessedData? result = box.isNotEmpty ? box.getAt(0) : null;

    final endTime = DateTime.now();
    print('Finished fetching school data at: $endTime');
    print('Time taken to fetch school data: ${endTime.difference(startTime).inMilliseconds} ms');

    return result;
  }

  Future<void> clearSchoolData() async {
    final box = Hive.box<ProcessedData>(boxName);

    await box.clear();
  }
}

@riverpod
LocalStorageRepository storageRepository(StorageRepositoryRef ref) {
  return LocalStorageRepository();
}
