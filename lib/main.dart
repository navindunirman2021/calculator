import 'package:flutter/material.dart';
import 'calculator_screen.dart';

void main() {
  runApp(const MyApp());// Entry point of the app, runs MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator', // Sets the title of the application
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData.dark(),// Uses a dark theme for the app
      home: const CalculatorScreen(), // Sets CalculatorScreen as the home screen
    );
  }
}