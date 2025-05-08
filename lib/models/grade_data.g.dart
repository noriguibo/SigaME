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
      subjects: (fields[0] as List).cast<SubjectGrade>(),
    );
  }

  @override
  void write(BinaryWriter writer, GradeData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.subjects);
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

class SubjectGradeAdapter extends TypeAdapter<SubjectGrade> {
  @override
  final int typeId = 6;

  @override
  SubjectGrade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectGrade(
      subject: fields[0] as String,
      professor: fields[1] as String,
      evaluations: (fields[2] as List).cast<Evaluation>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubjectGrade obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.subject)
      ..writeByte(1)
      ..write(obj.professor)
      ..writeByte(2)
      ..write(obj.evaluations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectGradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EvaluationAdapter extends TypeAdapter<Evaluation> {
  @override
  final int typeId = 7;

  @override
  Evaluation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Evaluation(
      name: fields[0] as String,
      date: fields[1] as String,
      grade: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Evaluation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.grade);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvaluationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
