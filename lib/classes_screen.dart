import 'package:flutter/material.dart';
import 'base_subject_detail_screen.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSubjectDetailScreen(
      title: 'AULAS',
      children: List.generate(2, (index) {
        return _buildCard(
          aula: index + 1,
          titulo: index == 0 ? 'Apresentação da Disciplina' : 'Plano de Projeto',
          metodologia: 'Aula Teórica',
          data: index == 0 ? '13/02/2025' : '20/02/2025',
          objetivo: index == 0
              ? 'Apresentação Professor; Apresentação conteúdo programático; Apresentação calendário semestre, avaliações e trabalhos.'
              : 'Elaboração do plano do projeto.',
        );
      }),
    );
  }

  Widget _buildCard({
    required int aula,
    required String titulo,
    required String metodologia,
    required String data,
    required String objetivo,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        color: Colors.white.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.red),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Aula nº: $aula", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("Título: $titulo"),
              Text("Metodologia: $metodologia"),
              Text("Data: $data"),
              Text("Objetivo:\n$objetivo"),
            ],
          ),
        ),
      ),
    );
  }
}
