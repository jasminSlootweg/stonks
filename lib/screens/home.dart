import 'package:flutter/material.dart';

import 'welcome_page.dart';
import '../widgets/top_section.dart';

import '../services/game_engine.dart';
import '../models/user.dart';
import '../models/company.dart';
import '../models/month_summary.dart';
import 'inbox.dart';  
import 'stocks.dart'; 

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primaryNavy = const Color.fromRGBO(2, 30, 67, 1);
  int currentMonthIndex = 0;
  
  final List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  /// Triggers the GameEngine to process financial and market shifts
  void _handleNextMonth() {
    setState(() {
      // 1. Run the Logic through the Service
      final summary = GameEngine.processNextMonth(widget.user, companies);

      // 2. Advance the UI Calendar
      currentMonthIndex = (currentMonthIndex + 1) % 12;

      // 3. Debt/Bankruptcy Check
      // Note: GameEngine already increments debtStrikes, so we just check the status here
      if (widget.user.debtStrikes >= 2) {
        _showBankruptcyGameOver();
      } else {
        _showSummaryDialog(summary, isWarning: widget.user.debtStrikes == 1);
      }
    });
  }

  /// Displays the results of the month transition
  void _showSummaryDialog(MonthSummary summary, {bool isWarning = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: primaryNavy,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isWarning ? Colors.redAccent : Colors.white10),
        ),
        title: Text(
          isWarning ? '⚠️ DEBT WARNING' : 'Monthly Report',
          style: TextStyle(
            color: isWarning ? Colors.redAccent : Colors.white, 
            fontWeight: FontWeight.bold
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isWarning)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Your balance is negative! Reach a positive balance by next month or your hustle ends.',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            _summaryRow('Salary', '+ \$${GameEngine.baseSalary}', Colors.greenAccent),
            _summaryRow('Investment Payouts', '+ \$${(summary.incomeEarned - GameEngine.baseSalary).toStringAsFixed(2)}', Colors.greenAccent),
            _summaryRow('Expenses', '- \$${summary.expensesPaid.toStringAsFixed(2)}', Colors.redAccent),
            _summaryRow('Market Flux', '\$${summary.stockChange.toStringAsFixed(2)}', 
                        summary.stockChange >= 0 ? Colors.greenAccent : Colors.redAccent),
            const Divider(color: Colors.white24, height: 20),
            _summaryRow('Total Change', '\$${summary.netChange.toStringAsFixed(2)}', Colors.white),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isWarning ? Colors.redAccent : Colors.greenAccent,
              foregroundColor: isWarning ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showBankruptcyGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text('BANKRUPT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30)),
        content: const Text('The banks have seized your assets. Your hustle is over.', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => const WelcomePage()), 
              (route) => false
            ),
            child: const Text('RESTART', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Top section displays Cash and Net Worth
            TopSection(user: widget.user),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    FeatureTile(
                      icon: Icons.inbox,
                      label: 'Inbox',
                      // THE FIX: await the navigation and refresh on return
                      onTap: () async {
                        await Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => InboxPage(user: widget.user))
                        );
                        setState(() {}); // Refresh HomePage UI
                      },
                    ),
                    FeatureTile(
                      icon: Icons.show_chart,
                      label: 'Stocks',
                      onTap: () async {
                        await Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => StocksPage(user: widget.user))
                        );
                        setState(() {}); // Refresh HomePage UI
                      },
                    ),
                    const FeatureTile(icon: Icons.account_balance_wallet, label: 'Budgeting'),
                    const FeatureTile(icon: Icons.pie_chart, label: 'Portfolio'),
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                border: const Border(top: BorderSide(color: Colors.white10, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.settings, color: Colors.white70), onPressed: () {}),
                  Text(
                    monthNames[currentMonthIndex].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.greenAccent, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 2.0
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.greenAccent, size: 30),
                    onPressed: _handleNextMonth,
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

// ---------- SUPPORTING WIDGETS ----------

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const FeatureTile({
    super.key, 
    required this.icon, 
    required this.label, 
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.greenAccent),
            const SizedBox(height: 12),
            Text(
              label, 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)
            ),
          ],
        ),
      ),
    );
  }
}