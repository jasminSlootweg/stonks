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
      totalInvestmentPayout += (investment.investmentCost * investment.rewardMultiplier);
      if (investment.nextMail != null) {
        followUpMails.add(investment.nextMail!);
      }
    }
    
    user.activeInvestments.clear();
    user.cash += totalInvestmentPayout;

    // 2. Select a Random Mail for the Month
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

    // 5. Standard Finances & Debt Strike Logic
    user.cash += baseSalary;
    user.cash -= user.monthlyCosts;

    // --- DEBT STRIKE LOGIC ---
    if (user.cash < 0) {
      user.debtStrikes++;
    }
    // -------------------------

    // 6. Manage Inbox Archive
    for (var mail in user.inbox) {
      mail.wasReadInPreviousMonth = true;
    }
    
    if (monthlyMail != null) {
      user.inbox.insert(0, monthlyMail);
    }
    
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