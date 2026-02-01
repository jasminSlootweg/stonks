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

  // --- RESTORED FIELD ---
  int debtStrikes = 0; 

  User({
    required this.name,
    required this.cash,
    required this.rent,
    required this.groceries,
    required this.transportation,
    required this.carInsurance,
    this.otherExpenses = 0.0,
  }) {
    inbox.add(welcomeEmail);
    calculateNetWorth();
  }

  double get monthlyCosts => rent + groceries + transportation + carInsurance + otherExpenses;

  // --- Financial Logic ---

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

  // --- Investment Logic (Deducts Cash) ---

  bool invest(Offer offer) {
    if (cash >= offer.investmentCost) {
      cash -= offer.investmentCost;
      activeInvestments.add(offer);
      calculateNetWorth();
      return true; 
    }
    return false; 
  }

  // --- Stock Market Logic ---

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