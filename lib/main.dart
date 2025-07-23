import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CotacoesApp());
}

class CotacoesApp extends StatelessWidget {
  const CotacoesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotações Financeiras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
