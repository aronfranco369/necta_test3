// file: models/processed_data.dart

import 'package:hive/hive.dart';

part 'processed_data.g.dart';

@HiveType(typeId: 0)
class ProcessedData extends HiveObject {
  @HiveField(0)
  final List<Map<String, dynamic>> errors;

  @HiveField(1)
  final List<Map<String, dynamic>> schools;

  @HiveField(2)
  final List<Map<String, dynamic>> qt;

  ProcessedData({
    required this.errors,
    required this.schools,
    required this.qt,
  });
}
