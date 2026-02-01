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
    double netMailResult = 0;

    // 1. Process Mail Investments
    double totalPayout = 0;
    double totalLosses = 0;
    List<Mail> followUpMails = [];

    for (var investment in user.activeInvestments) {
      double payout = investment.investmentCost * investment.rewardMultiplier;
      totalPayout += payout;

      if (investment.isScam) {
        double penalty = investment.investmentCost * 0.25;
        totalLosses += (investment.investmentCost + penalty);
        user.cash -= penalty;
      } else {
        totalLosses += investment.investmentCost;
      }

      if (investment.nextMail != null) followUpMails.add(investment.nextMail!);
    }
    
    user.cash += totalPayout;
    netMailResult = totalPayout - totalLosses;
    user.activeInvestments.clear();

    // 2. Select Mail & Update Markets
    List<Mail> availablePool = potentialMails.where((m) => !user.inbox.any((e) => e.subject == m.subject)).toList();
    Mail? monthlyMail = availablePool.isNotEmpty ? availablePool[_random.nextInt(availablePool.length)] : null;
    
    if (monthlyMail is News) {
      monthlyMail.affectedCompanies.forEach((c, i) => c.updateProbability(i));
    }
    for (var company in allCompanies) { company.updatePrice(); }

    // 3. Salary & Expenses
    user.cash += baseSalary;
    user.cash -= user.monthlyCosts;

    // 4. Update History & States
    if (user.cash < 0) { user.debtStrikes++; } else { user.debtStrikes = 0; }
    
    for (var mail in user.inbox) { mail.wasReadInPreviousMonth = true; }
    if (monthlyMail != null) user.inbox.insert(0, monthlyMail);
    user.inbox.insertAll(0, followUpMails);

    user.calculateNetWorth();
    
    // --- RECORD HISTORY FOR CHART ---
    user.cashHistory.add(user.cash);

    return MonthSummary(
      incomeEarned: baseSalary,
      expensesPaid: user.monthlyCosts,
      stockChange: user.calculatePortfolioValue(), 
      mailInvestmentResult: netMailResult,
      netChange: (user.cash + user.calculatePortfolioValue()) - oldTotalValue,
    );
  }
}