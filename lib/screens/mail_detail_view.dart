import 'package:flutter/material.dart';
import '../models/mail.dart';
import '../models/user.dart';

class MailDetailView extends StatelessWidget {
  final Mail mail;
  final User user;

  const MailDetailView({super.key, required this.mail, required this.user});

  @override
  Widget build(BuildContext context) {
    final bool isOffer = mail is Offer;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(2, 30, 67, 1),
      appBar: AppBar(
        title: const Text("Message Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mail.subject,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.white24),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  mail.body,
                  style: const TextStyle(color: Colors.white70, fontSize: 18, height: 1.5),
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            if (isOffer) ...[
              // ---------- INVEST BUTTON ----------
              ElevatedButton(
                onPressed: () {
                  final offer = mail as Offer;
                  // This triggers the cash deduction in the User model
                  bool success = user.invest(offer); 

                  if (success) {
                    user.inbox.remove(mail); // Remove deal from inbox
                    Navigator.pop(context); // Return to InboxPage
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invested \$${offer.investmentCost.toStringAsFixed(0)}"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Insufficient funds!"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "INVEST \$${(mail as Offer).investmentCost.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 12),

              // ---------- SKIP BUTTON ----------
              OutlinedButton(
                onPressed: () {
                  user.inbox.remove(mail); // Forever gone
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Deal declined.")),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent, width: 2),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Skip Deal", style: TextStyle(color: Colors.redAccent, fontSize: 18)),
              ),
            ] else ...[
              // BACK BUTTON FOR NEWS
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back to Inbox", style: TextStyle(color: Colors.greenAccent, fontSize: 16)),
                ),
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}