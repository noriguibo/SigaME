import 'package:flutter/material.dart';
import 'base_subject_detail_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login.dart';
import 'home_screen.dart';

import 'student_data.dart';
import '../models/grade_data.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  GradeData? _gradeData;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    final box = await Hive.openBox<GradeData>('gradeBox');
    final data = box.get('grades');

    print("📦 Dados carregados da gradeBox: $data");
    print("📚 Quantidade de matérias: ${data?.subjects.length}");

    setState(() {
      _gradeData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final studentBox = Hive.box<StudentData>('studentBox');
    final student = studentBox.getAt(0);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/background.png', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          Column(
            children: [
              _buildHeader(context, student),
              const SizedBox(height: 8),
              const Text("NOTAS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Expanded(
                child: _gradeData == null
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: _gradeData!.subjects
                              .map((subject) => _buildGradeCard(subject))
                              .toList(),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              _buildBackButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeCard(SubjectGrade subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subject.professor),
          const SizedBox(height: 8),
          Text("Média Final: ${_calculateAverage(subject.evaluations)}"),
          const SizedBox(height: 8),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              const TableRow(
                children: [
                  Text("Avaliação", textAlign: TextAlign.center),
                  Text("Data de lançamento", textAlign: TextAlign.center),
                  Text("Nota", textAlign: TextAlign.center),
                ],
              ),
              ...subject.evaluations.map((eval) => TableRow(
                    children: [
                      Text(eval.name, textAlign: TextAlign.center),
                      Text(eval.date, textAlign: TextAlign.center),
                      Text(eval.grade, textAlign: TextAlign.center),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateAverage(List<Evaluation> evaluations) {
    if (evaluations.isEmpty) return '0.0';

    double sum = 0;
    int count = 0;

    for (var e in evaluations) {
      double? grade = double.tryParse(e.grade.replaceAll(',', '.'));
      if (grade != null) {
        sum += grade;
        count++;
      }
    }

    return (count == 0) ? '0.0' : (sum / count).toStringAsFixed(1).replaceAll('.', ',');
  }

  Widget _buildHeader(BuildContext context, StudentData? student) {
    return Container(
      color: Colors.red[900],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey,
            backgroundImage: student?.studentPhoto != null
                ? MemoryImage(student!.studentPhoto!)
                : null,
            child: student?.studentPhoto == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(student?.studentName ?? '', style: const TextStyle(color: Colors.white)),
              Text(student?.studentID ?? '', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) => ElevatedButton(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.red),
          ),
        ),
        child: const Text("Voltar"),
      );
}
