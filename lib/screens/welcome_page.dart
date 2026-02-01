import 'package:flutter/material.dart';
import 'user_creation.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = 20.0;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(2, 30, 67, 1),
      body: Stack(
        children: [
          // 1. MAIN UI CONTENT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ---------- LOGO ----------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sidePadding),
                      child: Image.asset(
                        'assets/images/Stonks_logo.png',
                        width: screenWidth - (sidePadding * 2),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.monetization_on, size: 100, color: Colors.green),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ---------- TITLE ASSET ----------
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sidePadding),
                      child: Image.asset(
                        'assets/images/Title_Page_Asset.png',
                        width: screenWidth - (sidePadding * 2),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          "BIT SCAMS",
                          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // ---------- BUTTON GROUP ----------
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ---------- START (PLAY) BUTTON ----------
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserCreationPage()),
                            );
                          },
                          child: Image.asset(
                            'assets/images/play_button.png',
                            width: 220,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 2),

                        // ---------- SETTINGS BUTTON ----------
                        InkWell(
                          onTap: () {
                            // Settings logic
                          },
                          child: Image.asset(
                            'assets/images/settings_button.png',
                            width: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),

          // 2. BACKGROUND CHARACTER (STONKS GUY)
          // Using Positioned ensures he doesn't push the buttons or logo around.
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/stonks_guy.png',
              width: 160, // Adjust size based on your PNG resolution
              fit: BoxFit.contain,
              // Adding an errorBuilder so the app doesn't crash if the file is missing
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}