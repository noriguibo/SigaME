// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentDataAdapter extends TypeAdapter<StudentData> {
  @override
  final int typeId = 0;

  @override
  StudentData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentData(
      studentName: fields[0] as String,
      studentEmail: fields[1] as String,
      studentID: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.studentName)
      ..writeByte(1)
      ..write(obj.studentEmail)
      ..writeByte(2)
      ..write(obj.studentID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
