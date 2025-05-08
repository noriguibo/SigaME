import 'package:flutter/material.dart';
import 'base_subject_detail_screen.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(title: 'DISCIPLINAS'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white.withOpacity(0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Laboratório de Engenharia de Software',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const Text('Professora Cristina dos Santos Cô'),
                                const SizedBox(height: 10),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _subjectButton('Aulas', () {}),
                                    _subjectButton('Bibliografia', () {}),
                                    _subjectButton('Extra Classe', () {}),
                                    _subjectButton('Material', () {}),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              _bottomButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subjectButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white70,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }

  Widget _bottomButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.red),
          ),
        ),
        child: const Text('Voltar'),
      ),
    );
  }
}
