import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/company.dart';
import '../models/month_summary.dart';
import '../services/game_engine.dart';
import '../widgets/top_section.dart';
import 'inbox.dart';
import 'stocks.dart';
import 'welcome_page.dart';
import 'portfolio_page.dart'; // Ensure this exists in your lib/screens folder

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primaryNavy = const Color.fromRGBO(2, 30, 67, 1);
  int currentMonthIndex = 0;
  final List<String> monthNames = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

  void _handleNextMonth() {
    setState(() {
      final summary = GameEngine.processNextMonth(widget.user, companies);
      currentMonthIndex = (currentMonthIndex + 1) % 12;

      if (widget.user.debtStrikes >= 2) {
        _showBankruptcyGameOver();
      } else {
        _showSummaryDialog(summary, isWarning: widget.user.debtStrikes == 1);
      }
    });
  }

  void _showSummaryDialog(MonthSummary summary, {bool isWarning = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: primaryNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isWarning ? '⚠️ DEBT WARNING' : 'Monthly Report', 
                  style: TextStyle(color: isWarning ? Colors.redAccent : Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow('Salary', '+ \$${summary.incomeEarned}', Colors.greenAccent),
            _summaryRow('Expenses', '- \$${summary.expensesPaid.toStringAsFixed(2)}', Colors.redAccent),
            
            if (summary.mailInvestmentResult != 0)
              _summaryRow(
                summary.mailInvestmentResult > 0 ? 'Mail Profit' : 'Mail Loss/Scam',
                '${summary.mailInvestmentResult > 0 ? "+" : ""} \$${summary.mailInvestmentResult.toStringAsFixed(2)}',
                summary.mailInvestmentResult > 0 ? Colors.greenAccent : Colors.orangeAccent,
              ),

            _summaryRow('Stock Growth', '\$${summary.stockChange.toStringAsFixed(2)}', Colors.white70),
            const Divider(color: Colors.white24, height: 20),
            _summaryRow('Net Change', '\$${summary.netChange.toStringAsFixed(2)}', Colors.white, isBold: true),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: TextStyle(color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
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
        title: const Text('BANKRUPT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text('Your hustle has come to an end.', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomePage()), (r) => false),
            child: const Text('RESTART'),
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
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => InboxPage(user: widget.user)));
                        setState(() {});
                      }
                    ),
                    FeatureTile(
                      icon: Icons.show_chart, 
                      label: 'Stocks', 
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => StocksPage(user: widget.user)));
                        setState(() {});
                      }
                    ),
                    const FeatureTile(icon: Icons.account_balance_wallet, label: 'Budgeting'),
                    FeatureTile(
                      icon: Icons.pie_chart, 
                      label: 'Portfolio', 
                      onTap: () async {
                        // FIXED: Using Class Name 'PortfolioPage' instead of file name
                        await Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => PortfolioPage(user: widget.user),
                          ),
                        );
                        setState(() {}); 
                      }
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.settings, color: Colors.white54),
          Text(monthNames[currentMonthIndex], style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 2)),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.greenAccent, size: 30),
            onPressed: _handleNextMonth,
          ),
        ],
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const FeatureTile({super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.greenAccent),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}