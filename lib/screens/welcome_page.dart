import 'package:flutter/material.dart';
import 'user_creation.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            const Icon(Icons.monetization_on, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Financial Literacy App',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            
            // Start Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserCreationPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Start', style: TextStyle(fontSize: 20)),
            ),
            
            const SizedBox(height: 20),
            
            // Settings Button (Inactive)
            OutlinedButton(
              onPressed: () {
                // Does nothing for now
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Settings', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}