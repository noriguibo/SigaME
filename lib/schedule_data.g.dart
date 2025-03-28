// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleDataAdapter extends TypeAdapter<ScheduleData> {
  @override
  final int typeId = 1;

  @override
  ScheduleData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleData(
      classes: (fields[0] as List).cast<ClassData>(),
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.classes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassDataAdapter extends TypeAdapter<ClassData> {
  @override
  final int typeId = 2;

  @override
  ClassData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassData(
      weekDay: fields[0] as String,
      className: fields[1] as String,
      duration: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClassData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.weekDay)
      ..writeByte(1)
      ..write(obj.className)
      ..writeByte(2)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
