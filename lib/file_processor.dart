import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:necta_test3/hive/processed_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_processor.g.dart';

@riverpod
class FileProcessor extends _$FileProcessor {
  final _storage = FirebaseStorage.instance;
  static const String boxName = 'processed_data';

  @override
  Future<void> build() async {
    return;
  }

  Future<void> initHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProcessedDataAdapter());
    }
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<ProcessedData>(boxName);
    }
  }

  // Convert dynamic map to Map<String, dynamic>
  Map<String, dynamic> _convertToStringDynamicMap(Map<dynamic, dynamic> map) {
    return map.map((key, value) {
      if (value is Map) {
        return MapEntry(key.toString(), _convertToStringDynamicMap(value));
      } else if (value is List) {
        return MapEntry(key.toString(), _convertList(value));
      } else {
        return MapEntry(key.toString(), value);
      }
    });
  }

  // Convert list elements recursively
  dynamic _convertList(List list) {
    return list.map((element) {
      if (element is Map) {
        return _convertToStringDynamicMap(element);
      } else if (element is List) {
        return _convertList(element);
      } else {
        return element;
      }
    }).toList();
  }

  Future<ProcessedData> processAllFiles(String zipPath) async {
    // Download and extract zip
    final appDir = await getApplicationDocumentsDirectory();
    final zipFile = File(path.join(appDir.path, '2023.zip'));
    await _storage.refFromURL(zipPath).writeToFile(zipFile);

    // Extract zip contents
    final bytes = await zipFile.readAsBytes();
    final outputDir = Directory(path.join(appDir.path, '2023unzipped'))..createSync(recursive: true);

    for (final file in ZipDecoder().decodeBytes(bytes)) {
      if (file.isFile) {
        File(path.join(outputDir.path, file.name))
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as List<int>);
      }
    }

    // Process XZ files and collect results with proper type casting
    final results = {'errors': <Map<String, dynamic>>[], 'schools': <Map<String, dynamic>>[], 'qt': <Map<String, dynamic>>[]};

    for (final yearDir in outputDir.listSync().whereType<Directory>()) {
      for (final dataDir in yearDir.listSync().whereType<Directory>()) {
        final type = path.basename(dataDir.path);
        if (!results.containsKey(type)) continue;

        final xzFiles = dataDir.listSync().where((f) => f.path.endsWith('.xz'));

        for (final xzFile in xzFiles) {
          try {
            final decompressed = XZDecoder().decodeBytes(await (xzFile as File).readAsBytes());
            final dynamic decodedData = json.decode(utf8.decode(decompressed));

            if (decodedData is List) {
              final convertedList = decodedData.map((item) {
                if (item is Map) {
                  return _convertToStringDynamicMap(item);
                }
                return item;
              }).toList();
              results[type]!.addAll(convertedList.cast<Map<String, dynamic>>());
            } else if (decodedData is Map) {
              results[type]!.add(_convertToStringDynamicMap(decodedData));
            }
          } catch (e) {
            print('Error processing file ${xzFile.path}: $e');
            continue;
          }
        }
      }
    }

    // Create ProcessedData object
    final processedData = ProcessedData(
      errors: results['errors']!,
      schools: results['schools']!,
      qt: results['qt']!,
    );

    // Store in Hive
    await saveToHive(processedData);
    return processedData;
  }

  Future<void> saveToHive(ProcessedData data) async {
    final box = Hive.box<ProcessedData>(boxName);
    await box.clear();
    await box.add(data);
  }

  Future<ProcessedData?> getStoredData() async {
    final box = Hive.box<ProcessedData>(boxName);
    return box.isNotEmpty ? box.getAt(0) : null;
  }

  Future<void> clearStoredData() async {
    final box = Hive.box<ProcessedData>(boxName);
    await box.clear();
  }
}
