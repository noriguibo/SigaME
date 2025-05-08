import 'package:hive/hive.dart';

part 'grade_data.g.dart'; // importante para gerar o código

@HiveType(typeId: 5)
class GradeData extends HiveObject {
  @HiveField(0)
  List<SubjectGrade> subjects;

  GradeData({required this.subjects});
}

@HiveType(typeId: 6)
class SubjectGrade extends HiveObject {
  @HiveField(0)
  String subject;

  @HiveField(1)
  String professor;

  @HiveField(2)
  List<Evaluation> evaluations;

  SubjectGrade({
    required this.subject,
    required this.professor,
    required this.evaluations,
  });
}

@HiveType(typeId: 7)
class Evaluation extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String date;

  @HiveField(2)
  String grade;

  Evaluation({
    required this.name,
    required this.date,
    required this.grade,
  });
}
