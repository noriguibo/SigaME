import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login.dart';

//Database
import 'student_data.dart';
import 'schedule_data.dart';
import 'grade_data.dart';
import 'attendance_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StudentDataAdapter());
  Hive.registerAdapter(ScheduleDataAdapter());
  Hive.registerAdapter(GradeDataAdapter());
  Hive.registerAdapter(AttendanceDataAdapter());
  await Hive.openBox<StudentData>('studentBox');
  await Hive.openBox<ScheduleData>('scheduleBox');
  await Hive.openBox<GradeData>('gradeBox');
  await Hive.openBox<AttendanceData>('attendanceBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginScreen(),
       },
    );
  }
}