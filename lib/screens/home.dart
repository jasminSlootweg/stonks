import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/company.dart';
import '../models/month_summary.dart';
import '../models/randomEvent.dart';
import '../services/game_engine.dart';
import '../widgets/top_section.dart';
import 'inbox.dart';
import 'stocks.dart';
import 'welcome_page.dart';
import 'portfolio_page.dart';

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
        return;
      }

      final randomEvent = GameEngine.rollForRandomEvent(widget.user);
      _showSummaryDialog(summary, eventToTrigger: randomEvent);
    });
  }

  void _showSummaryDialog(MonthSummary summary, {RandomEvent? eventToTrigger}) {
    bool isWarning = widget.user.debtStrikes == 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: primaryNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isWarning ? '⚠️ DEBT WARNING' : 'Monthly Report', 
          style: TextStyle(color: isWarning ? Colors.redAccent : Colors.white, fontWeight: FontWeight.bold)
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow('Monthly Income', '+\$${summary.incomeEarned}', Colors.greenAccent),
            _summaryRow('Fixed Expenses', '-\$${summary.expensesPaid.toStringAsFixed(2)}', Colors.redAccent),
            const Divider(color: Colors.white24, height: 20),
            
            // --- STOCK CALCULATION SECTION ---
            _summaryRow('Portfolio Value', '\$${summary.totalStockValue.toStringAsFixed(2)}', Colors.white),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  summary.stockChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: summary.stockChange >= 0 ? Colors.greenAccent : Colors.redAccent,
                ),
                Text(
                  ' ${summary.stockChange >= 0 ? "+" : "-"}\$${summary.stockChange.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: summary.stockChange >= 0 ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // --- MAIL INVESTMENT SECTION ---
            if (summary.mailInvestmentResult != 0)
              _summaryRow(
                summary.mailInvestmentResult > 0 ? 'Mail Profit' : 'Mail Loss', 
                '${summary.mailInvestmentResult > 0 ? "+" : ""}\$${summary.mailInvestmentResult.toStringAsFixed(2)}',
                summary.mailInvestmentResult > 0 ? Colors.greenAccent : Colors.orangeAccent
              ),
            
            const Divider(color: Colors.white24, height: 20),
            _summaryRow('Net Change', '\$${summary.netChange.toStringAsFixed(2)}', Colors.white, isBold: true),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: () {
              Navigator.pop(context); // Close summary
              if (eventToTrigger != null) {
                _showRandomEventDialog(eventToTrigger); // Show random event next
              }
            },
            child: const Text('CONTINUE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showRandomEventDialog(RandomEvent event) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A2A53),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.greenAccent, width: 1),
        ),
        title: Text(event.title, style: const TextStyle(color: Colors.greenAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 15),
            // If the event has an immediate cash impact, show it clearly
            if (event.options.any((opt) => opt.label.contains('\$'))) 
              const Text("Your decision will impact your balance immediately.", 
                style: TextStyle(color: Colors.white54, fontSize: 11, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: event.options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              onPressed: () {
                setState(() {
                  option.onSelected(widget.user);
                  widget.user.calculateNetWorth();
                });
                Navigator.pop(context);
              },
              child: Text(option.label, style: const TextStyle(color: Colors.white)),
            ),
          ),
        )).toList(),
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
        content: const Text('You couldn\'t pay the bills. Your journey ends here.', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomePage()), (r) => false), child: const Text('RESTART')),
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
                    FeatureTile(icon: Icons.inbox, label: 'Inbox', onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => InboxPage(user: widget.user))); setState(() {}); }),
                    FeatureTile(icon: Icons.show_chart, label: 'Stocks', onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => StocksPage(user: widget.user))); setState(() {}); }),
                    const FeatureTile(icon: Icons.account_balance_wallet, label: 'Budgeting'),
                    FeatureTile(icon: Icons.pie_chart, label: 'Portfolio', onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => PortfolioPage(user: widget.user))); setState(() {}); }),
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
          IconButton(icon: const Icon(Icons.arrow_forward, color: Colors.greenAccent, size: 30), onPressed: _handleNextMonth),
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 42, color: Colors.greenAccent), const SizedBox(height: 12), Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))]),
      ),
    );
  }
}