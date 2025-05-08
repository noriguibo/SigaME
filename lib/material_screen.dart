import 'package:flutter/material.dart';
import 'base_subject_detail_screen.dart';

class MaterialScreen extends StatelessWidget {
  const MaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSubjectDetailScreen(
      title: 'MATERIAL',
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
              title: Text('${index + 1}. [Material #${index + 1}]'),
              trailing: const Icon(Icons.download),
            ),
          ),
        );
      }),
    );
  }
}
