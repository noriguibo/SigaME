import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart'; // For parsing HTML
import 'package:html/dom.dart'; // For working with HTML elements

class AuthService {
  static const String _loginUrl = 'https://siga.cps.sp.gov.br/aluno/login.aspx';

  final http.Client _client = http.Client(); // Maintain session cookies

  Future<bool> login(String username, String password) async {
  try {
    // Step 1: Get login page
    final loginPageResponse = await _client.get(Uri.parse(_loginUrl));
    if (loginPageResponse.statusCode != 200) {
      throw Exception('Failed to load login page');
    }

    // Debugging: Print initial page response
    print('Login Page Loaded: ${loginPageResponse.statusCode}');
    print('Response Headers: ${loginPageResponse.headers}');
    print('Response Body Snippet: ${loginPageResponse.body.substring(0, 500)}'); // Limit output

    // Parse HTML
    var document = parse(loginPageResponse.body);
    String viewState = document.querySelector('input[name="__VIEWSTATE"]')?.attributes['value'] ?? '';
    String eventValidation = document.querySelector('input[name="__EVENTVALIDATION"]')?.attributes['value'] ?? '';

    // Step 2: Send login request
    final response = await _client.post(
      Uri.parse(_loginUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': 'Mozilla/5.0',
      },
      body: {
        '__VIEWSTATE': viewState,
        '__EVENTVALIDATION': eventValidation,
        'username': username,
        'password': password,
        'btnLogin': 'Login',
      },
    );

    // Debugging: Print login response
    print('Login Response Status: ${response.statusCode}');
    print('Login Response Headers: ${response.headers}');
    print('Login Response Body Snippet: ${response.body.substring(0, 500)}');

    // Step 3: Check if login was successful
    if (response.body.contains('Usuário ou senha incorretos')) {
      return false;
    } else if (response.body.contains('Bem-vindo') || response.headers.containsKey('Set-Cookie')) {
      return true;
    } else {
      throw Exception('Unexpected login response: ${response.body.substring(0, 500)}');
    }
  } catch (e) {
    throw Exception('Erro ao fazer login: $e');
  }
}

}
