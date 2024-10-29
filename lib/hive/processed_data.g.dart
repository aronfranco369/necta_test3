// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processed_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProcessedDataAdapter extends TypeAdapter<ProcessedData> {
  @override
  final int typeId = 0;

  @override
  ProcessedData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProcessedData(
      errors: (fields[0] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      schools: (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      qt: (fields[2] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, ProcessedData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.errors)
      ..writeByte(1)
      ..write(obj.schools)
      ..writeByte(2)
      ..write(obj.qt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProcessedDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
