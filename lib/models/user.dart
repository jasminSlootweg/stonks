import 'company.dart';
import 'mail.dart';

class User {
  String name;
  double cash;
  double rent, groceries, transportation, carInsurance, otherExpenses;
  
  Map<Company, int> portfolio = {};
  List<Mail> inbox = []; 
  List<Offer> activeInvestments = []; 

  double netWorth = 0.0;
  int debtStrikes = 0;
  int totalScamsEncountered = 0;

  // --- NEW: History tracking for the chart ---
  List<double> cashHistory = [];

  User({
    required this.name,
    required this.cash,
    required this.rent,
    required this.groceries,
    required this.transportation,
    required this.carInsurance,
    this.otherExpenses = 0.0,
  }) {
    // Record starting cash as the first data point
    cashHistory.add(cash); 
    inbox.add(welcomeEmail);
    calculateNetWorth();
  }

  double get monthlyCosts => rent + groceries + transportation + carInsurance + otherExpenses;

  void calculateNetWorth() {
    double portfolioValue = 0.0;
    portfolio.forEach((company, shares) => portfolioValue += company.price * shares);
    netWorth = cash + portfolioValue;
  }

  double calculatePortfolioValue() {
    double total = 0.0;
    portfolio.forEach((company, shares) => total += company.price * shares);
    return total;
  }

  bool invest(Offer offer) {
    if (cash >= offer.investmentCost) {
      cash -= offer.investmentCost;
      activeInvestments.add(offer);
      calculateNetWorth();
      return true; 
    }
    return false; 
  }

  void buyStock(Company company, int shares) {
    double cost = company.price * shares;
    if (cash >= cost) {
      cash -= cost;
      portfolio[company] = (portfolio[company] ?? 0) + shares;
      calculateNetWorth();
    }
  }

  void sellStock(Company company, int shares) {
    int currentShares = portfolio[company] ?? 0;
    if (currentShares >= shares) {
      cash += company.price * shares;
      portfolio[company] = currentShares - shares;
      if (portfolio[company] == 0) portfolio.remove(company);
      calculateNetWorth();
    }
  }
}