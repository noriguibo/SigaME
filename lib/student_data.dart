import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'student_data.g.dart';

@HiveType(typeId: 0)
class StudentData {
  @HiveField(0)
  String studentName;

  @HiveField(1)
  String studentID;

  @HiveField(2)
  Uint8List? studentPhoto;

  StudentData({
    required this.studentName,
    required this.studentID,
    this.studentPhoto,
  });

  // Add this to handle potential type mismatches
  factory StudentData.fromMap(Map<dynamic, dynamic> map) {
    return StudentData(
      studentName: map['studentName'] as String,
      studentID: map['studentID'] as String,
      studentPhoto: map['studentPhoto'] is Uint8List 
          ? map['studentPhoto'] as Uint8List 
          : null,
    );
  }
}