import 'package:flutter/material.dart';
import 'base_subject_detail_screen.dart';

class ExtraClassesScreen extends StatelessWidget {
  const ExtraClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSubjectDetailScreen(
      title: 'EXTRA CLASSE',
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            color: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.red),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Título: [Título]"),
                  Text("Assunto: [Assunto]"),
                  Text("Data Inicial: [xx/xx/xxxx]"),
                  Text("Data Final: [xx/xx/xxxx]"),
                  Text("Valor da atividade: 0,0"),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
