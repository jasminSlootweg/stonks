import 'package:flutter/material.dart';
import '../models/user.dart';

class PortfolioPage extends StatelessWidget {
  final User user;
  const PortfolioPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const Color primaryNavy = Color.fromRGBO(2, 30, 67, 1);

    return Scaffold(
      backgroundColor: primaryNavy,
      appBar: AppBar(
        title: const Text("Performance", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- CASH CHART SECTION ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 220,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("CASH OVER TIME", style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    const SizedBox(height: 20),
                    Expanded(
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: CashChartPainter(user.cashHistory),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- ASSETS LIST ---
            _buildAssetTile("Available Cash", user.cash, Icons.wallet, Colors.greenAccent),
            _buildAssetTile("Stock Portfolio", user.calculatePortfolioValue(), Icons.pie_chart, Colors.blueAccent),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Divider(color: Colors.white10),
            ),

            // --- STOCK HOLDINGS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("STOCKS OWNED", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (user.portfolio.isEmpty)
                    const Text("No shares currently held.", style: TextStyle(color: Colors.white24)),
                  ...user.portfolio.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
                        Text("${entry.value} Shares", style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAssetTile(String label, double amount, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      trailing: Text("\$${amount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}

// Custom Painter for the Sparkline Chart
class CashChartPainter extends CustomPainter {
  final List<double> history;
  CashChartPainter(this.history);

  @override
  void paint(Canvas canvas, Size size) {
    if (history.length < 2) return;

    // --- SETUP SCALING ---
    double maxVal = history.reduce((a, b) => a > b ? a : b);
    double minVal = history.reduce((a, b) => a < b ? a : b);
    
    // Ensure we can always see the $0 line by including it in the range
    double viewMax = maxVal < 1000 ? 1000 : maxVal * 1.1;
    double viewMin = minVal > 0 ? -500 : minVal * 1.1;
    double range = viewMax - viewMin;

    // --- DRAW BANKRUPTCY LINE ($0) ---
    final zeroPaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double zeroY = size.height - ((0 - viewMin) / range) * size.height;
    // Only draw if $0 is within our current view
    if (zeroY >= 0 && zeroY <= size.height) {
      canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), zeroPaint);
    }

    // --- DRAW CASH HISTORY LINE ---
    final linePaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    for (int i = 0; i < history.length; i++) {
      double x = (size.width / (history.length - 1)) * i;
      double y = size.height - ((history[i] - viewMin) / range) * size.height;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}