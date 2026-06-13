import 'package:PokeDex_Flutter/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.redAccent,
      ),
      themeMode: ThemeMode
          .light, // Forces the application to ignore system dark mode completely
      home: const HomeScreen(),
    );
  }
}
