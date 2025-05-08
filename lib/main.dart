import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:typed_data';
import 'login.dart';

//Database
import 'student_data.dart';
import 'schedule_data.dart';
import 'models/grade_data.dart';
import 'attendance_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StudentDataAdapter());
  Hive.registerAdapter(ScheduleDataAdapter());
  Hive.registerAdapter(GradeDataAdapter());
  Hive.registerAdapter(SubjectGradeAdapter());
  Hive.registerAdapter(EvaluationAdapter());
  Hive.registerAdapter(AttendanceDataAdapter());
  await Hive.deleteBoxFromDisk('studentBox');
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


/*
              // Abrir tela de notas
              await _controller.runJavaScript("""
                const spans = document.querySelectorAll('.uc_appgrid-item span');
                for (const span of spans) {
                  if (span.textContent.trim().toLowerCase() === 'notas') {
                    span.closest('.uc_appgrid-item').click();
                    break;
                  }
                }
              """);

              await Future.delayed(const Duration(seconds: 3));

              // Coletar todos os cards de disciplinas
              final totalCards = await _controller.runJavaScriptReturningResult("""
                (function() {
                  return document.querySelectorAll('.uc_appcard.uc_pointer').length;
                })();
              """);

              int total = 0;
              if (totalCards is int) {
                total = totalCards;
              } else if (totalCards is String) {
                total = int.tryParse(totalCards.replaceAll('"', '')) ?? 0;
              } else {
                print("⚠️ Resultado inesperado ao contar cards: $totalCards");
              }

              List<SubjectGrade> subjectGrades = [];

              for (int i = 0; i < total; i++) {
                final disciplina = await _controller.runJavaScriptReturningResult("""
                  document.querySelectorAll('.uc_appcard-titlecontainer')[${i}]
                    .querySelector('.uc_appcard-title')?.textContent ?? ''
                """) as String;

                final professor = await _controller.runJavaScriptReturningResult("""
                  document.querySelectorAll('.uc_appcard-titlecontainer')[${i}].textContent
                    .split('\\n')
                    .filter(part => part.trim() !== '')[2]?.trim() ?? ''
                """) as String;

                await _controller.runJavaScript("""
                  document.querySelectorAll('.uc_appcard-titlecontainer')[${i}].click();
                """);
                await Future.delayed(const Duration(seconds: 1));                

                final avaliacoesJson = await _controller.runJavaScriptReturningResult('''
                  (function() {
                    try {
                      const resultados = [];
                      const cards = document.querySelectorAll('.uc_appcardsimples');
                      for (let card of cards) {
                        let notaElement = card.querySelector('.uc_appcardsimples-title center');
                        let nota = notaElement ? notaElement.innerText.trim() : '0.0';

                        let dataElement = card.querySelector('.uc_mb5');
                        let data = dataElement ? dataElement.innerText.trim() : 'Data não disponível';

                        let nome = 'Avaliação sem nome';
                        const linhas = card.querySelectorAll('.uc_flex-r');
                        for (let linha of linhas) {
                          const children = linha.children;
                          if (children.length >= 2) {
                            const label = children[0]?.innerText.trim();
                            const valor = children[1]?.innerText.trim();
                            if (label && label.includes('Avaliação')) {
                              nome = valor || nome;
                            }
                          }
                        }

                        resultados.push({
                          'nome': nome,
                          'data': data,
                          'nota': nota.replace(',', '.')
                        });
                      }
                      return JSON.stringify(resultados.length ? resultados : []);
                    } catch (e) {
                      return JSON.stringify([]);
                    }
                  })();
                ''') as String;

                List<Evaluation> evaluations = [];
                try {
                  final decoded = jsonDecode(avaliacoesJson);
                  if (decoded is List) {
                    evaluations = decoded.map<Evaluation>((a) {
                      return Evaluation(
                        name: a['nome'] ?? 'Avaliação sem nome',
                        date: a['data'] ?? 'Data não disponível',
                        grade: a['nota'] ?? '0.0',
                      );
                    }).toList();
                  }
                } catch (e) {
                  print("Erro ao processar JSON de avaliações: $e");
                }

                subjectGrades.add(SubjectGrade(
                  subject: disciplina.replaceAll('"', '').trim(),
                  professor: professor.replaceAll('"', '').trim(),
                  evaluations: evaluations,
                ));

                await _controller.runJavaScript('window.history.back();');
                await Future.delayed(const Duration(seconds: 1));
              }

              // Salvar notas no Hive
              try {
                final box = await Hive.openBox<GradeData>('gradeBox');
                if (subjectGrades.isEmpty) {
                  print("⚠️ Nenhuma disciplina encontrada para salvar.");
                  return;
                }

                await box.put('grades', GradeData(subjects: subjectGrades));
                print("✅ Notas salvas com sucesso no Hive!");
              } catch (e) {
                print("❌ Erro ao salvar notas: $e");
              }
*/