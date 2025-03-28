import 'package:hive/hive.dart';

part 'attendance_data.g.dart';

@HiveType(typeId: 3)
class AttendanceData {
  @HiveField(0)
  List<ClassAttendance> classAttendanceList;

  AttendanceData({required this.classAttendanceList});
}

@HiveType(typeId: 4)
class ClassAttendance {
  @HiveField(0)
  String className;

  @HiveField(1)
  String attendance;

  @HiveField(2)
  String absences;

  ClassAttendance({
    required this.className,
    required this.attendance,
    required this.absences,
  });
}