import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login(String username, String password) async {
  final url = Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx'); 

  // Extract GXState from the hidden field
  String gxState = ''; // Initialize the variable

  try {
    // Send the initial GET request to retrieve GXState (including cookies and tokens)
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // You need to extract GXState from the body of the response
      final document = html_parser.parse(response.body);
      final gxStateElement = document.querySelector('input[name="GXState"]');

      if (gxStateElement != null) {
        gxState = gxStateElement.attributes['value'] ?? '';
      } else {
        throw Exception('GXState not found');
      }

      // Prepare the POST data with the login credentials and extracted GXState
      final response = await http.post(
        url,
        body: {
          'vSIS_USUARIOID': username,
          'vSIS_USUARIOSENHA': password,
          'BTCONFIRMA': 'Confirmar',
          'GXState': gxState,  // Include the GXState value here
        },
      );

      if (response.statusCode == 200) {
        // Handle successful login (e.g., check the response body for confirmation)
        print('Login successful!');
      } else {
        print('Login failed');
      }
    }
  } catch (e) {
    print('Error during login: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 80),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : 
  ElevatedButton(
  onPressed: () async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      // Call _login and await it because it returns a Future
      await _login(username, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário ou senha não podem estar vazios!')),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.grey,
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  ),
  child: const Text(
    'Confirmar',
    style: TextStyle(color: Colors.white, fontSize: 16),
  ),
),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
