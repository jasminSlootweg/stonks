import '../models/user.dart';
import '../models/company.dart';
import '../models/month_summary.dart';
import '../models/mail.dart';

class GameEngine {
  static const double baseSalary = 2500.0;

  static MonthSummary processNextMonth(User user, List<Company> companies) {
    double oldPortfolioValue = user.calculatePortfolioValue();

    // 1. Process Sagas and Payouts
    double totalInvestmentPayout = 0;
    List<Mail> newMailsForInbox = [];

    for (var investment in user.activeInvestments) {
      // Calculate profit/return
      // Ponzi logic: They give you a little back (rewardMultiplier) to make you trust them
      double payout = investment.investmentCost * investment.rewardMultiplier;
      totalInvestmentPayout += payout;

      // If this investment leads to another email, queue it up
      if (investment.nextMail != null) {
        newMailsForInbox.add(investment.nextMail!);
      }
    }

    // Clear active investments (they processed)
    user.activeInvestments.clear();
    user.cash += totalInvestmentPayout;

    // 2. Standard Finances
    user.cash += baseSalary;
    user.cash -= user.monthlyCosts;

    // 3. Update Stocks & Probability
    for (var company in companies) {
      company.updatePrice();
    }

    // 4. Handle Inbox Maintenance
    for (var mail in user.inbox) {
      if (mail.isRead) mail.wasReadInPreviousMonth = true;
    }
    
    // Add saga follow-ups to the top of the inbox
    user.inbox.insertAll(0, newMailsForInbox);

    double newPortfolioValue = user.calculatePortfolioValue();
    double stockChange = newPortfolioValue - oldPortfolioValue;

    return MonthSummary(
      incomeEarned: baseSalary + totalInvestmentPayout,
      expensesPaid: user.monthlyCosts,
      stockChange: stockChange,
      netChange: (baseSalary + totalInvestmentPayout - user.monthlyCosts) + stockChange,
    );
  }
}