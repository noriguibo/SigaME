import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home_screen.dart';

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

            // Simula clique no botão "Entrar"
            if (url.contains('applogin.aspx')) {
              print("🔁 Simulando clique no botão...");

              await _controller.runJavaScript("""
                const button = document.querySelector('[onclick*="bootstrapclick(\\'LOGIN\\')"]');
                if (button) {
                  button.click();
                } else {
                  console.log("❌ Botão não encontrado.");
                }
              """);
            }

            // Quando for redirecionado para Microsoft login ou home, remove tela de loading
            if (url.contains('login.microsoftonline.com')) {
              Future.delayed(const Duration(milliseconds: 400), () {
                if (mounted) {
                  setState(() {
                    _hideWebView = false;
                  });
                }
              });
            }

            // Quando estiver logado, redireciona para HomeScreen
            if (url.contains('app.aspx')) {
              print("✅ Login concluído! Redirecionando...");

              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
              });
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
          // WebView (por trás da tela branca)
          WebViewWidget(controller: _controller),

          // Tela branca com loading
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
