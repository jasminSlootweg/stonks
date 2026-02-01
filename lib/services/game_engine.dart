import 'dart:math';
import '../models/user.dart';
import '../models/company.dart';
import '../models/mail.dart';
import '../models/month_summary.dart';

class GameEngine {
  static const double baseSalary = 2500.0;
  static final Random _random = Random();

  static MonthSummary processNextMonth(User user, List<Company> allCompanies) {
    double oldTotalValue = user.cash + user.calculatePortfolioValue();

    // 1. Process Saga Payouts & Chains
    double totalInvestmentPayout = 0;
    List<Mail> followUpMails = [];

    for (var investment in user.activeInvestments) {
      // Calculate profit (Cost * Multiplier)
      // Note: Multiplier 0.0 = Total loss (Scam), Multiplier 1.32 = 32% gain
      totalInvestmentPayout += (investment.investmentCost * investment.rewardMultiplier);
      
      // If there is a "Part 2" or "Part 3" email, it gets added next
      if (investment.nextMail != null) {
        followUpMails.add(investment.nextMail!);
      }
    }
    
    // Reset active investments for the new month
    user.activeInvestments.clear();
    user.cash += totalInvestmentPayout;

    // 2. Select a Random Mail for the Month
    // Avoid sending a saga opening if the user already has it in their inbox
    List<Mail> availablePool = potentialMails.where((m) {
      return !user.inbox.any((existing) => existing.subject == m.subject);
    }).toList();

    Mail? monthlyMail;
    if (availablePool.isNotEmpty) {
      monthlyMail = availablePool[_random.nextInt(availablePool.length)];
    }
    
    // 3. Apply Market News Impact
    if (monthlyMail != null && monthlyMail is News) {
      monthlyMail.affectedCompanies.forEach((company, impact) {
        company.updateProbability(impact);
      });
    }

    // 4. Update Stock Market Prices
    for (var company in allCompanies) {
      company.updatePrice();
    }

    // 5. Standard Finances
    user.cash += baseSalary;
    user.cash -= user.monthlyCosts;

    // 6. Manage Inbox Archive
    for (var mail in user.inbox) {
      mail.wasReadInPreviousMonth = true;
    }
    
    // New mail goes to the top
    if (monthlyMail != null) {
      user.inbox.insert(0, monthlyMail);
    }
    
    // Sagas appear above world news
    if (followUpMails.isNotEmpty) {
      user.inbox.insertAll(0, followUpMails);
    }

    user.calculateNetWorth();
    double newTotalValue = user.cash + user.calculatePortfolioValue();

    return MonthSummary(
      incomeEarned: baseSalary + totalInvestmentPayout,
      expensesPaid: user.monthlyCosts,
      stockChange: user.calculatePortfolioValue(), 
      netChange: newTotalValue - oldTotalValue,
    );
  }
}