import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home_screen.dart';

//Databases
import 'student_data.dart';
import 'schedule_data.dart';
import 'grade_data.dart';
import 'attendance_data.dart';

/*
[Faltas]

- uc_appcard uc_pointer
- uc_appcard-titlecontainer (Class ID)
- up_appcard-title (Class Name)

- uc_flex-r uc_flex-jcsb uc_mb5 uc_appborder-bottom [Strong]
- uc_applabel [0] = (Total)
- uc_applabel [1] = (Attendance)
- uc_applabel [2] = (Absense)
- uc_applabel [3] = (Frequency)

[Notas]

- uc_appcard uc_pointer [OnClick] / [Class Name]
-> OnClick [Javascript]

- uc_appcardsimples-container
- uc_appcardsimples-title uc_m10 [Amount]
- uc_flex-r [0][1][2] [Type] -> Check how many there is <-
*/

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final WebViewController _controller;
  final String sigaUrl = 'https://siga.cps.sp.gov.br/sigaaluno/applogin.aspx';
  bool _hideWebView = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            print("✅ Página carregada: $url");

            if (url.contains('applogin.aspx')) {
              print("🔁 Simulando clique no botão de login...");
              await _controller.runJavaScript("""
                const btn = document.querySelector('[onclick*="bootstrapclick(\\'LOGIN\\')"]');
                if (btn) btn.click();
              """);
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

            if (url.contains('app.aspx')) {
              setState(() {
                _hideWebView = true;
              });

              print("✅ Página app.aspx carregada!");

              // Clicar no botão "meu curso"
              await Future.delayed(const Duration(seconds: 1));
              await _controller.runJavaScript("""
                const cursoBtn = [...document.querySelectorAll('.uc_appfooter-button')]
                  .find(el => el.innerText.toLowerCase().includes('meu curso'));
                if (cursoBtn) cursoBtn.click();
              """);

              // Espera o conteúdo carregar e extrai os dados
              await Future.delayed(const Duration(seconds: 2));

              String nome = await _controller.runJavaScriptReturningResult("""
                (function() {
                  const el = document.querySelector('.uc_appinfo-title strong');
                  return el ? el.textContent : '';
                })();
              """) as String;

              String email = await _controller.runJavaScriptReturningResult("""
                (function() {
                  const flexRows = document.querySelectorAll('.uc_flex-r');
                  for (const row of flexRows) {
                    const label = row.children[0];
                    const value = row.children[1];
                    if (label && value && label.textContent.includes("E-mail")) {
                      return value.textContent.trim();
                    }
                  }
                  return '';
                })();
              """) as String;

              String ra = await _controller.runJavaScriptReturningResult("""
                (function() {
                  const flexRows = document.querySelectorAll('.uc_flex-r');
                  for (const row of flexRows) {
                    const label = row.children[0];
                    const value = row.children[1];
                    if (label && value && label.textContent.includes("RA")) {
                      return value.textContent.trim();
                    }
                  }
                  return '';
                })();
              """) as String;

              //var studentBox = await Hive.openBox('studentBox');
              final studentBox = Hive.box<StudentData>('studentBox');
              await studentBox.add(StudentData(
                studentName: nome,
                studentEmail: email,
                studentID: ra,
              ));

              // Ir para HomeScreen (você pode passar os dados depois por argumento se quiser)
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(sigaUrl));
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
