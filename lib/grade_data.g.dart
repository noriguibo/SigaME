// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeDataAdapter extends TypeAdapter<GradeData> {
  @override
  final int typeId = 5;

  @override
  GradeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradeData(
      classGrades: (fields[0] as List).cast<ClassGrade>(),
    );
  }

  @override
  void write(BinaryWriter writer, GradeData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.classGrades);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassGradeAdapter extends TypeAdapter<ClassGrade> {
  @override
  final int typeId = 6;

  @override
  ClassGrade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassGrade(
      className: fields[0] as String,
      grade: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClassGrade obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.className)
      ..writeByte(1)
      ..write(obj.grade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassGradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
