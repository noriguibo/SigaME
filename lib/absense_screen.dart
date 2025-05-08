import 'package:flutter/material.dart';

class AbsenseScreen extends StatelessWidget {
  const AbsenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/background.png', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 8),
              const Text("FALTAS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: List.generate(5, (index) => _buildAbsenceCard(index + 1)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildBackButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    color: Colors.red[900],
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        const CircleAvatar(radius: 24, backgroundColor: Colors.grey),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Renan Leite Gabriel", style: TextStyle(color: Colors.white)),
            Text("renan.gabriel2@fatec.sp.gov.br", style: TextStyle(color: Colors.white, fontSize: 12)),
            Text("0050482223014", style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
        const Spacer(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.logout, color: Colors.white)),
      ],
    ),
  );

  Widget _buildAbsenceCard(int number) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.red),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Matéria $number", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Table(
          children: const [
            TableRow(children: [
              Text("Aulas", textAlign: TextAlign.center),
              Text("Presença", textAlign: TextAlign.center),
            ]),
            TableRow(children: [
              Text("Ausências", textAlign: TextAlign.center),
              Text("Frequência", textAlign: TextAlign.center),
            ]),
          ],
        ),
      ],
    ),
  );

  Widget _buildBackButton(BuildContext context) => ElevatedButton(
    onPressed: () => Navigator.pop(context),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: const BorderSide(color: Colors.red),
      ),
    ),
    child: const Text("Voltar"),
  );
}
