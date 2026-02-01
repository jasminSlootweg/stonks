class MonthSummary {
  final double incomeEarned;
  final double expensesPaid;
  final double stockChange; // The $ difference (e.g., +50 or -20)
  final double totalStockValue; // <--- ADD THIS LINE
  final double netChange;
  final double mailInvestmentResult; 

  MonthSummary({
    required this.incomeEarned,
    required this.expensesPaid,
    required this.stockChange,
    required this.totalStockValue, // <--- ADD THIS LINE
    required this.netChange,
    required this.mailInvestmentResult,
  });
}