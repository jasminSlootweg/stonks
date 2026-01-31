import 'package:flutter/material.dart';
import 'screens/welcome_page.dart'; // Import the new welcome page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financial Literacy App',
      theme: ThemeData(
        // Using ColorScheme is the modern way to set primary colors in Flutter
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const WelcomePage(), // Load the WelcomePage first
    );
  }
}