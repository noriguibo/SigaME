import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'home_screen.dart';

class WebViewPage extends StatefulWidget {
  final String username;
  final String password;

  const WebViewPage({super.key, required this.username, required this.password});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (url.contains('home_screen.dart')) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx'));

    // Inject JavaScript after the page loads
    Future.delayed(Duration(seconds: 2), () {
      _injectLoginScript();
    });
  }

  void _injectLoginScript() {
    final script = '''
      document.getElementById("vSIS_USUARIOID").value = "${widget.username}";
      document.getElementById("vSIS_USUARIOSENHA").value = "${widget.password}";
      document.querySelector('input[name="BTCONFIRMA"]').click();
    ''';
    _controller.runJavaScript(script);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login via WebView")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
