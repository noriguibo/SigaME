import 'package:hive/hive.dart';

part 'student_data.g.dart';

@HiveType(typeId: 0) // Unique ID for your model
class StudentData {
  @HiveField(0)
  String studentName;

  @HiveField(1)
  String studentEmail;

  @HiveField(2)
  String studentID;

  StudentData({
    required this.studentName,
    required this.studentEmail,
    required this.studentID,
  });
}