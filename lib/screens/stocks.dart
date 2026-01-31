import 'package:flutter/material.dart';
import '../widgets/top_section.dart';
import '../models/company.dart'; 
import 'dart:math';
import '../models/user.dart';

class StocksPage extends StatefulWidget {
  // FIX: Added the user parameter so the page knows who is buying/selling
  final User user;

  const StocksPage({super.key, required this.user});

  @override
  State<StocksPage> createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  List<Company> companyList = [];

  @override
  void initState() {
    super.initState();
    // Use the global companies list or a filtered version
    companyList = List.from(companies);

    // Initialize logic remains similar, but ensure we don't overwrite 
    // existing prices if they've already been set globally.
    for (var company in companyList) {
      if (company.price == 0) {
        company.price = 50 + (companyList.indexOf(company) * 5.0);
      }
    }
  }

  void updateAllPrices() {
    setState(() {
      for (var company in companyList) {
        company.updatePrice();
      }
      // After prices change, the user's net worth must be recalculated
      widget.user.calculateNetWorth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Stocks'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Next Month',
            onPressed: updateAllPrices,
          ),
        ],
      ),
      body: Column(
        children: [
          // FIX: Pass the widget.user to the TopSection to show live cash/net worth
          TopSection(user: widget.user),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: companyList.length,
              itemBuilder: (context, index) {
                final company = companyList[index];
                // Check how many the user actually owns from the User model
                final int sharesOwned = widget.user.portfolio[company] ?? 0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  company.name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  company.sector,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '\$${company.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: company.goingUp ? Colors.green : Colors.red,
                                ),
                              ),
                              Icon(
                                company.goingUp ? Icons.arrow_upward : Icons.arrow_downward,
                                size: 16,
                                color: company.goingUp ? Colors.green : Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(company.description, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                      const SizedBox(height: 10),
                      
                      // ---------- BUY / SELL SECTION ----------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Owned: $sharesOwned',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              // SELL BUTTON
                              ElevatedButton(
                                onPressed: sharesOwned > 0 
                                  ? () => setState(() => widget.user.sellStock(company, 1)) 
                                  : null,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100], foregroundColor: Colors.red),
                                child: const Text('Sell'),
                              ),
                              const SizedBox(width: 8),
                              // BUY BUTTON
                              ElevatedButton(
                                onPressed: widget.user.cash >= company.price 
                                  ? () => setState(() => widget.user.buyStock(company, 1)) 
                                  : null,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[100], foregroundColor: Colors.green),
                                child: const Text('Buy'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}