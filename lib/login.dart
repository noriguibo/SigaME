import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'home_screen.dart';
//Databases
import 'student_data.dart';
import 'schedule_data.dart';
import 'models/grade_data.dart';
import 'attendance_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController _controller;
  final String sigaUrl = 'https://siga.cps.sp.gov.br/sigaaluno/applogin.aspx';
  bool _hideWebView = true;
  bool _loggedIn = false;
  bool _meuCursoClicked = false;
  bool _notasClicked = false;
  bool _gradesExtracted = false;

  @override
  void initState() {
    super.initState();
    print("➡️ initState chamado");

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          print("✅ Flutter recebeu mensagem do WebView: ${message.message}");
          if (message.message == 'loggedIn') {
            _navigateToMeuCurso();
          } else if (message.message == 'meuCursoClicked') {
            _navigateToNotas();
          } else if (message.message == 'notasLoaded') {
            _extractGrades();
          } else if (message.message.startsWith('grades:')) {
            _processAndSaveGrades(message.message.substring('grades:'.length));
          }
        },
      )
      ..loadRequest(Uri.parse(sigaUrl))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            print("✅ Página carregada (onPageFinished): $url");
            if (url.contains('applogin.aspx') && !_loggedIn) {
              await _simulateLogin();
            }
            if (url.contains('login.microsoftonline.com')) {
              Future.delayed(const Duration(milliseconds: 400), () {
                if (mounted) {
                  setState(() {
                    _hideWebView = false;
                  });
                }
              });
            }
          },
        ),
      );
  }

  Future<void> _simulateLogin() async {
    print("➡️ _simulateLogin chamado");
    await _controller.runJavaScript("""
      console.log('Tentando clicar no botão de login...');
      const btn = document.querySelector('[onclick*="bootstrapclick(\\'LOGIN\\')"]');
      if (btn) {
        console.log('Botão de login encontrado, clicando...');
        btn.click();
        setTimeout(() => {
          console.log('Enviando mensagem loggedIn para Flutter');
          FlutterChannel.postMessage('loggedIn');
        }, 2000);
      } else {
        console.log('Botão de login NÃO encontrado!');
      }
    """);
    setState(() {
      _loggedIn = true;
    });
    print("⬅️ _simulateLogin concluído");
  }

  Future<void> _navigateToMeuCurso() async {
    if (_meuCursoClicked) {
      print("➡️ _navigateToMeuCurso já chamado, ignorando.");
      return;
    }
    setState(() {
      _hideWebView = true;
    });
    print("➡️ _navigateToMeuCurso chamado");

    int retryCount = 0;
    const maxRetries = 10;
    const delayDuration = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      final dynamic cursoButtonExists = await _controller.runJavaScriptReturningResult("""
        [...document.querySelectorAll('.uc_appfooter-button')]
          .some(el => el.innerText.toLowerCase().includes('meu curso'));
      """);

      if (cursoButtonExists == true) {
        print("✅ Botão Meu curso encontrado!");
        await _controller.runJavaScript("""
          document.querySelectorAll('.uc_appfooter-button')
            .forEach(el => {
              if (el.innerText.toLowerCase().includes('meu curso')) {
                console.log('Botão Meu curso encontrado, clicando...');
                el.click();
                setTimeout(() => {
                  console.log('Enviando mensagem meuCursoClicked para Flutter');
                  FlutterChannel.postMessage('meuCursoClicked');
                }, 2000);
              }
            });
        """);
        setState(() {
          _meuCursoClicked = true;
        });
        print("⬅️ _navigateToMeuCurso concluído");
        return;
      } else {
        print("⏳ Aguardando o carregamento da seção 'Meu curso' (tentativa ${retryCount + 1})...");
        await Future.delayed(delayDuration);
        retryCount++;
      }
    }
    print("❌ Falha ao encontrar a seção 'Meu curso' após $maxRetries tentativas.");
  }

  Future<void> _navigateToNotas() async {
    if (_notasClicked) {
      print("➡️ _navigateToNotas já chamado, ignorando.");
      return;
    }
    print("➡️ _navigateToNotas chamado");
    await Future.delayed(const Duration(seconds: 3));
    await _controller.runJavaScript("""
      console.log('Tentando encontrar e clicar no item Notas...');
      document.querySelectorAll('.uc_appgrid-item')
        .forEach(el => {
          const spanElement = el.querySelector('span');
          if (spanElement && spanElement.textContent.trim().toLowerCase() === 'notas') {
            console.log('Item Notas encontrado, clicando...');
            el.click();
            setTimeout(() => {
              console.log('Enviando mensagem notasLoaded para Flutter');
              FlutterChannel.postMessage('notasLoaded');
            }, 3000);
          }
        });
    """);
    setState(() {
      _notasClicked = true;
    });
    print("⬅️ _navigateToNotas concluído");
  }

  Future<void> _extractGrades() async {
    if (_gradesExtracted) {
      print("➡️ _extractGrades já chamado, ignorando.");
      return;
    }
    print("➡️ _extractGrades chamado");
    await Future.delayed(const Duration(seconds: 3));

    final dynamic flutterChannelExists = await _controller.runJavaScriptReturningResult("""
      typeof FlutterChannel !== 'undefined';
    """);
    print("✅ typeof FlutterChannel: $flutterChannelExists");
    if (flutterChannelExists != true) {
      print("⚠️ FlutterChannel is NOT defined in the WebView!");
      return;
    } else {
      print("✅ FlutterChannel IS defined in the WebView.");
    }

    final totalCards = await _controller.runJavaScriptReturningResult("""
      document.querySelectorAll('.uc_appcard.uc_pointer').length;
    """);

    int total = 0;
    if (totalCards is int) {
      total = totalCards;
    } else if (totalCards is String) {
      total = int.tryParse(totalCards.replaceAll('"', '')) ?? 0;
    } else {
      print("⚠️ Resultado inesperado ao contar cards: $totalCards");
      return;
    }

    print("➡️ Iniciando extração de $total disciplinas...");
    String allGradesJson = '[';
    for (int i = 0; i < total; i++) {
      print("➡️ Extraindo dados da disciplina $i...");
      final disciplina = await _controller.runJavaScriptReturningResult("""
        document.querySelectorAll('.uc_appcard.uc_pointer .uc_appcard-titlecontainer .uc_appcard-title')[${i}]?.textContent?.trim() ?? ''
      """) as String?;
      print("➡️ Disciplina $i: $disciplina");

      final professor = await _controller.runJavaScriptReturningResult("""
        (() => {
          const containerText = document.querySelectorAll('.uc_appcard.uc_pointer .uc_appcard-titlecontainer')[${i}]?.textContent?.trim();
          console.log('Container Text for discipline ${i}:', containerText);
          const disciplinaElement = document.querySelectorAll('.uc_appcard.uc_pointer .uc_appcard-titlecontainer .uc_appcard-title')[${i}]?.textContent?.trim();
          const codigoElement = containerText?.split(disciplinaElement)?.[0]?.trim();

          if (containerText && disciplinaElement && codigoElement) {
            const professorName = containerText.substring(codigoElement.length + disciplinaElement.length).trim();
            console.log('Extracted Professor Name for discipline ${i}:', professorName);
            return professorName;
          }
          return '';
        })();
      """) as String?;
      print("➡️ Professor $i: $professor");

      await _controller.runJavaScript("""
        document.querySelectorAll('.uc_appcard.uc_pointer')[${i}].click();
        console.log('Clicou no card da disciplina $i');
      """);
      await Future.delayed(const Duration(seconds: 1));

      final avaliacoesJson = await _controller.runJavaScriptReturningResult('''
        (function() {
          try {
            const resultados = [];
            const evaluationContainers = document.querySelectorAll('.uc_appcardsimples-container .uc_appcardsimples');
            console.log('Encontrados ' + evaluationContainers.length + ' cards de avaliação.');
            for (let card of evaluationContainers) {
              let notaElement = card.querySelector('.uc_appcardsimples-title center');
              let nota = notaElement ? notaElement.innerText.trim().replace(',', '.') : '0.0';
              let dataElement = card.querySelector('.uc_mb5');
              let data = dataElement ? dataElement.innerText.trim() : 'Data não disponível';
              let nomeElement = card.querySelector('.uc_flex-r:nth-child(3) div:nth-child(2)');
              let nome = nomeElement ? nomeElement.innerText.trim() : 'Avaliação sem nome';
              resultados.push({
                'nome': nome,
                'data': data,
                'nota': nota
              });
            }
            const jsonResult = JSON.stringify(resultados);
            console.log('JSON de avaliações da disciplina $i: ' + jsonResult);
            return jsonResult;
          } catch (e) {
            console.error('Erro ao extrair avaliações da disciplina $i: ' + e);
            return JSON.stringify([]);
          }
        })();
      ''') as String?;
      print("➡️ Avaliações JSON da disciplina $i: $avaliacoesJson");

      await _controller.runJavaScript("""
        document.querySelectorAll('.uc_appbtvoltar.uc_pointer')
          .forEach(el => {
            const text = el.innerText.toLowerCase().trim();
            const icon = el.querySelector('i.fas.fa-chevron-left');
            if (text === 'voltar' && icon) {
              console.log('Botão Voltar encontrado, clicando...');
              el.click();
            }
          });
        console.log('Tentou voltar para a tela de disciplinas $i');
      """);
      await Future.delayed(const Duration(seconds: 1));
    }

    if (allGradesJson.endsWith(',')) {
      allGradesJson = allGradesJson.substring(0, allGradesJson.length - 1);
    }
    allGradesJson += ']';
    print("➡️ JSON final das notas: $allGradesJson");

    await _controller.runJavaScript("""
      console.log('Enviando grades para Flutter: ' + '$allGradesJson');
      FlutterChannel.postMessage('grades:' + '$allGradesJson');
    """);

    setState(() {
      _gradesExtracted = true;
    });
    print("⬅️ _extractGrades concluído");
  }

  Future<void> _processAndSaveGrades(String gradesJson) async {
    print("➡️ _processAndSaveGrades chamado com JSON: $gradesJson");
    List<SubjectGrade> subjectGrades = [];
    try {
      final List<dynamic> decoded = jsonDecode(gradesJson);
      subjectGrades = decoded.map((subjectData) {
        final List<dynamic> evaluationsData = subjectData['evaluations'] ?? [];
        final List<Evaluation> evaluations = evaluationsData.map<Evaluation>((eval) {
          return Evaluation(
            name: eval['nome'] ?? 'Avaliação sem nome',
            date: eval['data'] ?? 'Data não disponível',
            grade: eval['nota'] ?? '0.0',
          );
        }).toList();
        return SubjectGrade(
          subject: subjectData['subject'] ?? '',
          professor: subjectData['professor'] ?? '',
          evaluations: evaluations,
        );
      }).toList();

      final box = await Hive.openBox<GradeData>('gradeBox');
      if (subjectGrades.isEmpty) {
        print("⚠️ Nenhuma disciplina encontrada para salvar.");
        return;
      }
      await box.put('grades', GradeData(subjects: subjectGrades));
      print("✅ Notas salvas com sucesso no Hive!");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print("❌ Erro ao processar e salvar notas: $e");
    }
    print("⬅️ _processAndSaveGrades concluído");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_hideWebView)
            Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}