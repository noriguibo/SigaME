import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'student_data.dart';
import 'login.dart';
import 'grades_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    
    final studentBox = Hive.box<StudentData>('studentBox');
    final student = studentBox.getAt(0);

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              _buildHeader(context, student),
              const SizedBox(height: 20),
              _buildTodayClassCard(),
              const SizedBox(height: 20),
              _buildMenuButton(context, 'Notas'),
              _buildMenuButton(context, 'Faltas'),
              _buildMenuButton(context, 'Horário'),
              //_buildMenuButton(context, 'Avisos', hasNotification: true),
              //const SizedBox(height: 30),
              _buildCardButton('Acessar carteirinha'),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StudentData? student) {
    return Container(
      color: Colors.red[900],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey,
            backgroundImage: student?.studentPhoto != null
                ? MemoryImage(student!.studentPhoto!)
                : null,
            child: student?.studentPhoto == null
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(student?.studentName ?? '', style: const TextStyle(color: Colors.white)),
              Text(student?.studentID ?? '', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayClassCard() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 320,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Aula de hoje', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Quarta-feira, 18/09/2024'),
            Text('Laboratório 3.1'),
            Text('Laboratório de Engenharia de Software'),
            Text('Professora Cristina dos Santos Cô'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, {bool hasNotification = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Stack(
        children: [
          ElevatedButton(
            onPressed: () {
              switch(title){
                case "Notas":
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GradesScreen()));
                  break;
                case "Faltas":
                  break;
                case "Disciplinas":
                  break;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Colors.red),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size.fromHeight(48),
            ),
            child: Align(alignment: Alignment.center, child: Text(title)),
          ),
          if (hasNotification)
            const Positioned(
              right: 12,
              top: 8,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Text('1', style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardButton(String label) {
    return OutlinedButton(
      onPressed: () {
        // Adicione ação da carteirinha
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }
}
