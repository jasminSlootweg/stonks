import 'package:flutter/material.dart';
import '../widgets/top_section.dart';
import '../models/user.dart';

class InboxPage extends StatefulWidget {
  // FIX: Added the user requirement
  final User user;

  const InboxPage({super.key, required this.user});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  bool isUnread = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: const Text('Inbox'),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // FIX: Pass the user from the widget to TopSection
            TopSection(user: widget.user),

            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() => isUnread = false);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Welcome to Scam Life!'),
                          content: const Text(
                            'Welcome to Scam Life!\n\n'
                            'Your inbox will deliver monthly newsletters, economic shifts, and insights.\n\n'
                            'Be cautious — some offers may be scams.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Got it'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          if (isUnread)
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome to Scam Life!',
                                  style: TextStyle(
                                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your monthly investment intelligence…',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}