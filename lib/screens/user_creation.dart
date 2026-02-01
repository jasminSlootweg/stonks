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

    final user = User(
      name: name,
      cash: 2000.0, 
      rent: 800.0,          
      groceries: 200.0,     
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
      backgroundColor: const Color.fromRGBO(2, 30, 67, 1),
      // Stack allows us to put the character behind the input UI
      body: Stack(
        children: [
          // ---------- BACKGROUND CHARACTER ----------
          Positioned(
            bottom: -10, // Slightly offset to look like he's peeking in
            left: -10,
            child: Opacity(
              opacity: 0.6, // Blends him into the navy background
              child: Image.asset(
                'assets/images/stonks_guy.png',
                width: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),

          // ---------- MAIN INPUT UI ----------
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'WHAT IS YOUR NAME?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      hintText: 'ENTER NAME',
                      hintStyle: const TextStyle(color: Colors.white24),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // ---------- CONTINUE BUTTON ----------
                  InkWell(
                    onTap: _continue,
                    splashColor: Colors.transparent, 
                    highlightColor: Colors.transparent,
                    child: Image.asset(
                      'assets/images/continue_button.png',
                      width: 260,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}