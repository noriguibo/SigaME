import 'package:hive/hive.dart';

part 'schedule_data.g.dart';

@HiveType(typeId: 1)
class ScheduleData {
  @HiveField(0)
  List<ClassData> classes;

  ScheduleData({
    required this.classes,
  });
}

@HiveType(typeId: 2)
class ClassData {
  @HiveField(0)
  String weekDay;

  @HiveField(1)
  String className;

  @HiveField(2)
  String duration;

  ClassData({
    required this.weekDay,
    required this.className,
    required this.duration,
  });
}