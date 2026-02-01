import 'dart:math';
import '../models/user.dart';
import '../models/company.dart';
import '../models/mail.dart';
import '../models/month_summary.dart';
import '../models/randomEvent.dart';
import '../data/events_random.dart';

class GameEngine {
  static final Random _random = Random();

  static MonthSummary processNextMonth(User user, List<Company> allCompanies) {
    // Record starting values for comparison
    double startCash = user.cash;
    double startStockValue = user.calculatePortfolioValue();
    double oldTotalNetWorth = startCash + startStockValue;
    
    double netMailResult = 0;

    // --- 1. MAIL & SCAMS ---
    double totalPayout = 0;
    double totalLosses = 0;
    List<Mail> followUpMails = [];

    for (var investment in user.activeInvestments) {
      double payout = investment.investmentCost * investment.rewardMultiplier;
      totalPayout += payout;

      if (investment.isScam) {
        // Penalty is 25% of the original cost
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

    // --- 2. MARKETS (Stock Price Update) ---
    // Track stock value before prices shift
    double stockValueBeforeMarketMove = user.calculatePortfolioValue();

    List<Mail> availablePool = potentialMails
        .where((m) => !user.inbox.any((e) => e.subject == m.subject))
        .toList();
    
    Mail? monthlyMail = availablePool.isNotEmpty 
        ? availablePool[_random.nextInt(availablePool.length)] 
        : null;
    
    if (monthlyMail is News) {
      monthlyMail.affectedCompanies.forEach((c, i) => c.updateProbability(i));
    }

    // Update prices for all companies
    for (var company in allCompanies) { 
      company.updatePrice(); 
    }

    // Calculate the difference in value caused by market movement
    double stockValueAfterMarketMove = user.calculatePortfolioValue();
    double stockDiff = stockValueAfterMarketMove - stockValueBeforeMarketMove;

    // --- 3. SALARY & STANDARD EXPENSES ---
    user.cash += user.baseSalary;
    user.cash -= user.monthlyCosts;

    // --- 4. UPDATE GAME STATE ---
    if (user.cash < 0) { 
      user.debtStrikes++; 
    } else { 
      user.debtStrikes = 0; 
    }
    
    for (var mail in user.inbox) { 
      mail.wasReadInPreviousMonth = true; 
    }
    
    if (monthlyMail != null) user.inbox.insert(0, monthlyMail);
    user.inbox.insertAll(0, followUpMails);

    user.calculateNetWorth();
    user.cashHistory.add(user.cash);

    // Return the summary with all comparison data needed for UI
    return MonthSummary(
      incomeEarned: user.baseSalary,
      expensesPaid: user.monthlyCosts,
      stockChange: stockDiff, // Higher or Lower than before
      totalStockValue: stockValueAfterMarketMove, // New current value
      mailInvestmentResult: netMailResult, // Profit or Loss from mail
      netChange: (user.cash + stockValueAfterMarketMove) - oldTotalNetWorth,
    );
  }

  /// --- RANDOM EVENT ROLLER ---
  static RandomEvent? rollForRandomEvent(User user) {
    // Priority 1: Consequence-based events
    if (user.hasCar) {
      double breakdownChance = 0.03 + (user.maintenanceSkips * 0.20);
      if (_random.nextDouble() < breakdownChance) {
        return RandomEvent(
          title: "Car Breakdown",
          description: "Neglect has consequences. Your engine has failed due to lack of maintenance.",
          options: [
            EventOption(label: "Repair (\$600)", onSelected: (u) { 
              u.cash -= 600; 
              u.maintenanceSkips = 0; 
            }),
            EventOption(label: "Abandon Car", onSelected: (u) { 
              u.hasCar = false; 
              u.transportation = 50.0; 
              u.maintenanceSkips = 0; 
            }),
          ],
        );
      }
    }

    if (user.electricalSkips > 0) {
      if (_random.nextDouble() < (user.electricalSkips * 0.15)) {
        return RandomEvent(
          title: "Electrical Fire!",
          description: "Faulty wiring triggered a fire. Urgent repairs are mandatory.",
          options: [
            EventOption(label: "Pay \$1500 for repairs", onSelected: (u) { 
              u.cash -= 1500; 
              u.electricalSkips = 0; 
            }),
          ],
        );
      }
    }

    // Priority 2: General Life Events (15% chance)
    if (_random.nextDouble() < 0.15) {
      List<RandomEvent> validPool = allRandomEvents.where((e) {
        if (e.title == "Buy a Car" && user.hasCar) return false;
        if (e.title == "Partner Talks About Kids" && user.hasKids) return false;
        if ((e.title == "Child Medical Bill" || e.title == "Birthday Party") && !user.hasKids) return false;
        if (e.title == "Routine Car Maintenance" && !user.hasCar) return false;
        return true;
      }).toList();

      if (validPool.isNotEmpty) {
        return validPool[_random.nextInt(validPool.length)];
      }
    }
    return null;
  }
}