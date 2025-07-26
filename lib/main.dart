import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/conversor_screen.dart';

void main() {
  runApp(const CotacoesApp());
}

class CotacoesApp extends StatelessWidget {
  const CotacoesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotações BSF',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.trending_up, color: Colors.white),
              SizedBox(width: 8),
              Text('Cotações BSF',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: Colors.blue.shade700,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(Icons.list),
                text: 'Cotações',
              ),
              Tab(
                icon: Icon(Icons.swap_horiz),
                text: 'Conversor',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            ConversorScreen(),
          ],
        ),
      ),
    );
  }
}
