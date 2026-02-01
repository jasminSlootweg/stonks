import 'package:flutter/material.dart';
import '../models/user.dart';

class TopSection extends StatelessWidget {
  final User user;

  const TopSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---------- STONKS GUY (NOW VERTICALLY ALIGNED) ----------
          Image.asset(
            'assets/images/stonks_guy.png',
            width: 120, // Adjust size as needed
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
          
          const SizedBox(height: 10), // Gap between character and data

          // ---------- NET WORTH SECTION ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Net Worth',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '\$${user.netWorth.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // ---------- CASH & COSTS SECTION ----------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              border: const Border(
                left: BorderSide(color: Colors.white10),
                right: BorderSide(color: Colors.white10),
                bottom: BorderSide(color: Colors.white10),
              ),
            ),
            child: Column(
              children: [
                _buildMiniRow('Cash', user.cash, Colors.white70),
                const SizedBox(height: 6),
                _buildMiniRow('Monthly Costs', user.monthlyCosts, Colors.redAccent.withOpacity(0.8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniRow(String label, double value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 13, 
            fontWeight: FontWeight.w600, 
            color: valueColor,
          ),
        ),
      ],
    );
  }
}