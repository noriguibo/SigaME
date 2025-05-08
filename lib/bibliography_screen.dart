import 'package:flutter/material.dart';
import 'base_subject_detail_screen.dart';

class BibliographyScreen extends StatelessWidget {
  const BibliographyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSubjectDetailScreen(
      title: 'BIBLIOGRAFIA',
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            color: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.red),
            ),
            child: ListTile(
              title: Text('${index + 1}. [Bibliografia #${index + 1}]'),
            ),
          ),
        );
      }),
    );
  }
}
