class MonthSummary {
  final double incomeEarned;
  final double expensesPaid;
  final double stockChange;
  final double netChange;
  final double mailInvestmentResult; // Positive for profit, negative for loss/scam

  MonthSummary({
    required this.incomeEarned,
    required this.expensesPaid,
    required this.stockChange,
    required this.netChange,
    required this.mailInvestmentResult,
  });
}