import 'package:flutter/material.dart';

class BaseSubjectDetailScreen extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const BaseSubjectDetailScreen({
    super.key,
    required this.title,
    required this.children,
  });

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
              CustomAppBar(title: title),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: children),
                ),
              ),
              Padding(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[900],
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Renan Leite Gabriel", style: TextStyle(color: Colors.white)),
                  Text("renan.gabriel2@fatec.sp.gov.br", style: TextStyle(color: Colors.white)),
                  Text("005048223034", style: TextStyle(color: Colors.white)),
                ],
              ),
              Spacer(),
              Icon(Icons.logout, color: Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(title, style: const TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
