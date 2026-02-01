import 'package:flutter/material.dart';
import 'screens/welcome_page.dart';

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
        // Setting the default font family for the whole app
        fontFamily: 'PixelFont', 

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark, // Optional: Makes text white by default
        ),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}