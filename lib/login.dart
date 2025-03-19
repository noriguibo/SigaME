import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'home_screen.dart'; // Import HomeScreen
import 'package:flutter/foundation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _dio = Dio();
  final cookieJar = CookieJar();
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      /*
      * Login Request
      */
      final loginResponse = await _dio.post(
        'https://siga.cps.sp.gov.br/aluno/login.aspx',
        data: {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (loginResponse.statusCode == 200) {
        var url = Uri.parse('https://siga.cps.sp.gov.br/aluno/home.aspx');
        var response = await http.get(url);

        BeautifulSoup bs = BeautifulSoup(response.body);

        var studentName = bs.find('*', id: 'span_MPW0041vPRO_PESSOALNOME')?.text ?? 'Unknown';
        var studentEmail = bs.find('*', id: 'span_MPW0041vACD_ALUNOCURSOREGISTROACADEMICOCURSO')?.text ?? 'Unknown';
        var studentID = bs.find('*', id: 'span_MPW0041vINSTITUCIONALFATEC')?.text ?? 'Unknown';

        if (kDebugMode) {
          print('Student Name: $studentName');
          print('Student Email: $studentEmail');
          print('Student ID: $studentID');
        }
        
        /*
        * Login Successful, go to Home_Screen and send information
        */
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              studentName: studentName.toString(),
              studentEmail: studentEmail.toString(),
              studentID: studentID.toString(),
            ),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Login failed: ${loginResponse.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e'); //Other Exceptions
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
