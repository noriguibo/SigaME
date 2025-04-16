import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'student_data.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final studentBox = Hive.box<StudentData>('studentBox');
    final student = studentBox.getAt(0);
    
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${student?.studentName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('${student?.studentEmail}'),
                        Text('${student?.studentID}'),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app, size: 30, color: Colors.black),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
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
                        Text('Aula de hoje', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text('Quarta-feira, 18/09/2024'),
                        Text('Laboratório 3.1'),
                        Text('Laboratório de Engenharia de Software'),
                        Text('Professora Cristina dos Santos Cô'),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildMenuButton('Notas'),
                            _buildMenuButton('Faltas'),
                            _buildMenuButton('Horário'),
                            _buildMenuButton('Avisos', hasNotification: true),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Acessar carteirinha'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String title, {bool hasNotification = false}) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Center(child: Text(title, style: TextStyle(fontSize: 16))),
        ),
        if (hasNotification)
          Positioned(
            right: 8,
            top: 8,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.red,
              child: Text('1', style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
          ),
      ],
    );
  }
}