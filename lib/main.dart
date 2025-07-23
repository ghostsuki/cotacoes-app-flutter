import 'package:flutter/material.dart';

void main() {
  runApp(const CotacoesApp());
}

class CotacoesApp extends StatelessWidget {
  const CotacoesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotações Financeiras',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotações BSF'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Bem-vindo ao App de Cotações!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Consulte cotações financeiras em tempo real',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
