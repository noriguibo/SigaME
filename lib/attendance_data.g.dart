// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceDataAdapter extends TypeAdapter<AttendanceData> {
  @override
  final int typeId = 3;

  @override
  AttendanceData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceData(
      classAttendanceList: (fields[0] as List).cast<ClassAttendance>(),
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.classAttendanceList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ClassAttendanceAdapter extends TypeAdapter<ClassAttendance> {
  @override
  final int typeId = 4;

  @override
  ClassAttendance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassAttendance(
      className: fields[0] as String,
      attendance: fields[1] as String,
      absences: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClassAttendance obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.className)
      ..writeByte(1)
      ..write(obj.attendance)
      ..writeByte(2)
      ..write(obj.absences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassAttendanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
