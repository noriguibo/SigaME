import 'package:hive/hive.dart';

part 'grade_data.g.dart';

@HiveType(typeId: 5)
class GradeData {
  @HiveField(0)
  List<ClassGrade> classGrades;

  GradeData({required this.classGrades});
}

@HiveType(typeId: 6)
class ClassGrade {
  @HiveField(0)
  String className;

  @HiveField(1)
  String grade;

  ClassGrade({required this.className, required this.grade});
}