import 'company.dart';

class User {
  final String name;

  double cash; // liquid money available
  Map<Company, int> portfolio; // company -> how many stocks owned
  double netWorth; // calculated dynamically

  // Monthly recurring payments
  double rent;
  double groceries;
  double transportation;
  double carInsurance;
  double otherExpenses;

  User({
    required this.name,
    this.cash = 1000.0, // starting cash
    Map<Company, int>? portfolio,
    this.rent = 800.0,
    this.groceries = 300.0,
    this.transportation = 150.0,
    this.carInsurance = 100.0,
    this.otherExpenses = 50.0,
  })  : portfolio = portfolio ?? {},
        netWorth = 0 {
    calculateNetWorth();
  }

  /// Total monthly costs
  double get monthlyCosts =>
      rent + groceries + transportation + carInsurance + otherExpenses;

  /// Update the net worth based on cash + portfolio value
  void calculateNetWorth() {
    double portfolioValue = 0;
    portfolio.forEach((company, amount) {
      portfolioValue += company.price * amount;
    });
    netWorth = cash + portfolioValue;
  }

  /// Buy stocks
  bool buyStock(Company company, int amount) {
    double totalPrice = company.price * amount;
    if (cash >= totalPrice) {
      cash -= totalPrice;
      portfolio.update(company, (old) => old + amount, ifAbsent: () => amount);
      calculateNetWorth();
      return true;
    }
    return false; // not enough cash
  }

  /// Sell stocks
  bool sellStock(Company company, int amount) {
    if (portfolio.containsKey(company) && portfolio[company]! >= amount) {
      cash += company.price * amount;
      portfolio.update(company, (old) => old - amount);
      if (portfolio[company] == 0) portfolio.remove(company);
      calculateNetWorth();
      return true;
    }
    return false; // not enough stocks
  }

  /// Pay monthly expenses
  void payMonthlyExpenses() {
    cash -= monthlyCosts;
    if (cash < 0) cash = 0;
    calculateNetWorth();
  }
}
