import 'package:flutter/material.dart';
import 'home.dart';
import '../models/user.dart';

class UserCreationPage extends StatefulWidget {
  const UserCreationPage({super.key});

  @override
  State<UserCreationPage> createState() => _UserCreationPageState();
}

class _UserCreationPageState extends State<UserCreationPage> {
  final TextEditingController _nameController = TextEditingController();

  void _continue() {
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    // FIX: We only pass arguments that exist in the User constructor.
    // cash: 5000.0 is allowed because 'this.cash' is in the constructor.
    // monthlyCosts and netWorth are removed because they are calculated by the class.
    final user = User(
      name: name,
      cash: 5000.0, 
      rent: 800.0,          // You can customize these to change the 
      groceries: 200.0,     // resulting monthlyCosts calculation.
      transportation: 100.0,
      carInsurance: 100.0,
      otherExpenses: 0.0,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Your Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Your name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _continue,
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                backgroundColor: Colors.green, // Updated from 'primary' for newer Flutter versions
                foregroundColor: Colors.white, // Updated from 'onPrimary'
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}