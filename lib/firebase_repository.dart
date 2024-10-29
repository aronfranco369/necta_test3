import 'package:firebase_storage/firebase_storage.dart';
import 'package:archive/archive.dart';
import 'package:necta_test3/hive/processed_data.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_repository.g.dart';

class FirebaseRepository {
  final _storage = FirebaseStorage.instance;

  Future<ProcessedData> fetchAndProcessSchoolData(String zipPath) async {
    final startTime = DateTime.now();
    print('Start fetching and processing school data at: $startTime');

    final extractedData = await _downloadAndExtractZip(zipPath);
    final processedData = await _processExtractedData(extractedData);

    final endTime = DateTime.now();
    print('Finished fetching and processing school data at: $endTime');
    print('Total time taken: ${endTime.difference(startTime).inSeconds} seconds');

    return processedData;
  }

  Future<Directory> _downloadAndExtractZip(String zipPath) async {
    final startTime = DateTime.now();
    print('Start downloading and extracting zip file at: $startTime');

    final appDir = await getApplicationDocumentsDirectory();
    final zipFile = File(path.join(appDir.path, '2023.zip'));

    await _storage.refFromURL(zipPath).writeToFile(zipFile);
    final bytes = await zipFile.readAsBytes();

    final outputDir = Directory(path.join(appDir.path, '2023unzipped'))..createSync(recursive: true);

    for (final file in ZipDecoder().decodeBytes(bytes)) {
      if (file.isFile) {
        File(path.join(outputDir.path, file.name))
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as List<int>);
      }
    }

    final endTime = DateTime.now();
    print('Finished downloading and extracting zip file at: $endTime');
    print('Time taken for downloading and extracting: ${endTime.difference(startTime).inSeconds} seconds');

    return outputDir;
  }

  Future<ProcessedData> _processExtractedData(Directory outputDir) async {
    final startTime = DateTime.now();
    print('Start processing extracted data at: $startTime');

    final results = {'errors': <Map<String, dynamic>>[], 'schools': <Map<String, dynamic>>[], 'qt': <Map<String, dynamic>>[]};

    for (final yearDir in outputDir.listSync().whereType<Directory>()) {
      await _processYearDirectory(yearDir, results);
    }

    final endTime = DateTime.now();
    print('Finished processing extracted data at: $endTime');
    print('Time taken for processing data: ${endTime.difference(startTime).inSeconds} seconds');

    return ProcessedData(
      errors: results['errors']!,
      schools: results['schools']!,
      qt: results['qt']!,
    );
  }

  Future<void> _processYearDirectory(Directory yearDir, Map<String, List<Map<String, dynamic>>> results) async {
    final startTime = DateTime.now();
    print('Start processing year directory ${yearDir.path} at: $startTime');

    for (final dataDir in yearDir.listSync().whereType<Directory>()) {
      final type = path.basename(dataDir.path);

      if (!results.containsKey(type)) continue;

      final xzFiles = dataDir.listSync().where((f) => f.path.endsWith('.xz'));

      for (final xzFile in xzFiles) {
        await _processXZFile(xzFile as File, type, results);
      }
    }

    final endTime = DateTime.now();
    print('Finishe  sd processing year directory ${yearDir.path} at: $endTime');
    print('Time taken for processing year directory: ${endTime.difference(startTime).inSeconds} seconds');
  }

  Future<void> _processXZFile(File xzFile, String type, Map<String, List<Map<String, dynamic>>> results) async {
    final startTime = DateTime.now();

    try {
      final decompressed = XZDecoder().decodeBytes(await xzFile.readAsBytes());
      final dynamic decodedData = json.decode(utf8.decode(decompressed));

      if (decodedData is List) {
        results[type]!.addAll(_convertList(decodedData).cast<Map<String, dynamic>>());
      } else if (decodedData is Map) {
        results[type]!.add(_convertToStringDynamicMap(decodedData));
      }
    } catch (e) {
      print('Error processing file ${xzFile.path}: $e');
    }

    final endTime = DateTime.now();

    print('Time taken for processing XZ file: ${endTime.difference(startTime).inSeconds} seconds');
  }

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

  List<dynamic> _convertList(List list) {
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
}

@riverpod
FirebaseRepository firebaseRepository(FirebaseRepositoryRef ref) {
  return FirebaseRepository();
}
