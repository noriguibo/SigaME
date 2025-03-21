import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'home_screen.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Dio _dio = Dio(BaseOptions(
    followRedirects: false,
    validateStatus: (status) {
      return status != null && (status < 400 || status == 303);
    },
  ));

  final CookieJar _cookieJar = CookieJar();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loginPageResponse =
          await _dio.get('https://siga.cps.sp.gov.br/aluno/login.aspx');
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

      final loginResponse = await _dio.post(
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

      final cookies = await _cookieJar.loadForRequest(
          Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx'));
      print('Saved Cookies: $cookies');

      String? redirectUrl = loginResponse.headers['location']?.first;

      if (loginResponse.statusCode == 303) {
        print('Redirect URL: $redirectUrl');
      }

      if (loginResponse.statusCode == 303 && redirectUrl != null) {
          // Construct the full redirect URL
          final fullRedirectUrl = 'https://siga.cps.sp.gov.br/aluno/$redirectUrl';

          final redirectedResponse = await _dio.get(
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

      final homeResponse =
          await _dio.get('https://siga.cps.sp.gov.br/aluno/home.aspx');
      if (!homeResponse.data.contains('span_MPW0041vPRO_PESSOALNOME')) {
        throw Exception("❌ Login failed! Still on login page.");
      }

      BeautifulSoup bs = BeautifulSoup(homeResponse.data);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            bs: bs,
          ),
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