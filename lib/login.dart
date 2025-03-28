import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'home_screen.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

//Database
import 'student_data.dart';
import 'schedule_data.dart';
import 'grade_data.dart';
import 'attendance_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String studentName = 'Loading...';
  String studentEmail = 'Loading...';
  String studentID = 'Loading...';

  final Dio dio = Dio(BaseOptions(
    followRedirects: false,
    validateStatus: (status) {
      return status != null && (status < 400 || status == 303);
    },
  ));

  final CookieJar cookieJar = CookieJar();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final studentBox = Hive.box<StudentData>('studentBox');
  final scheduleBox = Hive.box<ScheduleData>('scheduleBox');
  final gradeBox = Hive.box<GradeData>('gradeBox');
  final attendanceBox = Hive.box<AttendanceData>('attendanceBox');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<void> _loadData() async {
    final studentData = studentBox.get('studentData');
    final scheduleData = scheduleBox.get('scheduleData');
    final gradeData = gradeBox.get('gradeData');
    final attendanceData = attendanceBox.get('attendanceData');

    if (studentData == null || scheduleData == null || gradeData == null || attendanceData == null) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    try {
      final homeResponse =
          await dio.get('https://siga.cps.sp.gov.br/aluno/home.aspx',
            options: Options(
              headers: {
                'Referer': 'https://siga.cps.sp.gov.br/aluno/login.aspx',
              }
            )
          );

      if (!homeResponse.data.contains('span_MPW0041vPRO_PESSOALNOME')) {
        throw Exception("❌ Login failed! Still on login page.");
      }

      BeautifulSoup bs = BeautifulSoup(homeResponse.data);

      await studentBox.put(
        'studentData',
        StudentData(
          studentName: bs.find('*', id: 'span_MPW0041vPRO_PESSOALNOME')?.text ?? 'Unknown',
          studentEmail: bs.find('*', id: 'span_MPW0041vACD_ALUNOCURSOREGISTROACADEMICOCURSO')?.text ?? 'Unknown',
          studentID: bs.find('*', id: 'span_MPW0041vINSTITUCIONALFATEC')?.text ?? 'Unknown',
        ),
      );

      final horarioResponse =
          await dio.get('https://siga.cps.sp.gov.br/aluno/horario.aspx',
            options: Options(
              headers: {
                'Referer': 'https://siga.cps.sp.gov.br/aluno/home.aspx',
              }
            )
          );

      bs = BeautifulSoup(horarioResponse.data);

      List<ClassData> classList = [
        ClassData(
          weekDay: 'Segunda-Feira',
          className: 'Unknown',
          duration: 'Unknown',
        ),
        ClassData(
          weekDay: 'Terça-Feira',
          className: 'Unknown',
          duration: 'Unknown',
        ),
        ClassData(
          weekDay: 'Quarta-Feira',
          className: 'Unknown',
          duration: 'Unknown',
        ),
        ClassData(
          weekDay: 'Quinta-Feira',
          className: 'Unknown',
          duration: 'Unknown',
        ),
        ClassData(
          weekDay: 'Sexta-Feira',
          className: 'Unknown',
          duration: 'Unknown',
        ),
        ClassData(
          weekDay: 'Sábado',
          className: 'Unknown',
          duration: 'Unknown',
        ),
      ];

      await scheduleBox.put(
        'scheduleData',
        ScheduleData(
          classes: classList,
        ),
      );

      final notasResponse =
          await dio.get('https://siga.cps.sp.gov.br/aluno/notas.aspx',
            options: Options(
              headers: {
                'Referer': 'https://siga.cps.sp.gov.br/aluno/horario.aspx',
              }
            )
          );

      bs = BeautifulSoup(notasResponse.data);

      List<ClassGrade> gradeList = [
        ClassGrade(
          className: 'Class 1',
          grade: 'Unknown',
        ),
        ClassGrade(
          className: 'Class 2',
          grade: 'Unknown',
        ),
        ClassGrade(
          className: 'Class 3',
          grade: 'Unknown',
        ),
        ClassGrade(
          className: 'Class 4',
          grade: 'Unknown',
        ),
        ClassGrade(
          className: 'Class 5',
          grade: 'Unknown',
        ),
        ClassGrade(
          className: 'Class 6',
          grade: 'Unknown',
        ),
        ClassGrade(
          className: 'Class 7',
          grade: 'Unknown',
        ),
        ClassGrade(
          className: 'Class 8',
          grade: 'Unknown',
        ),
      ];

      await gradeBox.put(
        'gradeData',
        GradeData(
          classGrades: gradeList,
        ),
      );

      final faltasResponse =
          await dio.get('https://siga.cps.sp.gov.br/aluno/faltas.aspx',
            options: Options(
              headers: {
                'Referer': 'https://siga.cps.sp.gov.br/aluno/horarios.aspx',
              }
            )
          );

      bs = BeautifulSoup(faltasResponse.data);

      List<ClassAttendance> attendanceList = [
        ClassAttendance(
          className: 'Class 1',
          attendance: 'Unknown',
          absences: 'Unknown',
        ),
        ClassAttendance(
          className: 'Class 2',
          attendance: 'Unknown',
          absences: 'Unknown',
        ),
        ClassAttendance(
          className: 'Class 3',
          attendance: 'Unknown',
          absences: 'Unknown',
        ),
        ClassAttendance(
          className: 'Class 4',
          attendance: 'Unknown',
          absences: 'Unknown',
        ),
        ClassAttendance(
          className: 'Class 5',
          attendance: 'Unknown',
          absences: 'Unknown',
        ),
        ClassAttendance(
          className: 'Class 6',
          attendance: 'Unknown',
          absences: 'Unknown',
        ),
        ClassAttendance(
          className: 'Class 7',
          attendance: 'Unknown',
          absences: 'Unknown',
        ),
        ClassAttendance(
          className: 'Class 8',
          attendance: 'Unknown',
          absences: 'Unknown',
        ),
      ];

      await attendanceBox.put(
        'attendanceData',
        AttendanceData(
          classAttendanceList: attendanceList,
        ),
      );

    } catch (e) {

    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loginPageResponse =
          await dio.get('https://siga.cps.sp.gov.br/aluno/login.aspx');
      if (loginPageResponse.statusCode != 200) {
        throw Exception("Failed to load login page.");
      }

      final document = html.parse(loginPageResponse.data);
      final gxStateElement = document.querySelector('input[name="GXState"]');
      final gxStateValue = gxStateElement?.attributes['value'] ?? '';

      if (gxStateValue.isEmpty) {
        throw Exception("Failed to extract GXState.");
      }

      // Decode the GXState JSON string
      Map<String, dynamic> gxStateJson = jsonDecode(gxStateValue);

      // Add the event name and the missing parameters.
      gxStateJson["_EventName"] = "E'EVT_CONFIRMAR'.";
      gxStateJson["_MODE"] = "";
      gxStateJson["Mode"] = "";
      gxStateJson["IsModified"] = "1";

      // Encode the modified GXState back to a JSON string
      final modifiedGxStateValue = jsonEncode(gxStateJson);

      final loginResponse = await dio.post(
        'https://siga.cps.sp.gov.br/aluno/login.aspx',
        data: {
          'vSIS_USUARIOID': _usernameController.text,
          'vSIS_USUARIOSENHA': _passwordController.text,
          'BTCONFIRMA': 'Confirmar',
          'GXState': modifiedGxStateValue, // Use the modified GXState
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Referer': 'https://siga.cps.sp.gov.br/aluno/login.aspx',
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
          },
        ),
      );

      print('Login Response Body: ${loginResponse.data}');

      final cookies = await cookieJar.loadForRequest(
          Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx'));
      print('Saved Cookies: $cookies');

      String? redirectUrl = loginResponse.headers['location']?.first;

      if (loginResponse.statusCode == 303) {
        print('Redirect URL: $redirectUrl');
      }

      if (loginResponse.statusCode == 303 && redirectUrl != null) {
          // Construct the full redirect URL
          final fullRedirectUrl = 'https://siga.cps.sp.gov.br/aluno/$redirectUrl';

          final redirectedResponse = await dio.get(
            fullRedirectUrl,
            options: Options(
              headers: {
                'Referer': 'https://siga.cps.sp.gov.br/aluno/login.aspx',
              },
            ),
          );

          if (redirectedResponse.statusCode == 200) {
            print('✅ Successfully followed the redirect to home.');
          } else {
            throw Exception("Failed to follow redirect.");
          }
      }

      _loadData();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}