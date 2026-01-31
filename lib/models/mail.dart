import 'company.dart';

/// The base class for all inbox messages
abstract class Mail {
  final String subject;
  final String body;
  bool isRead;

  Mail({
    required this.subject,
    required this.body,
    this.isRead = false,
  });
}

// ---------- SUBCLASS: NEWS ----------

class News extends Mail {
  /// Links multiple companies to their respective modifiers.
  /// Example: { Tesla: 0.15, Ford: -0.05 }
  final Map<Company, double> affectedCompanies;

  News({
    required String subject,
    required String body,
    required this.affectedCompanies,
  }) : super(subject: subject, body: body);
}

// ---------- SUBCLASS: OFFERS ----------

class Offer extends Mail {
  final double investmentCost;
  final bool isScam;
  
  /// The potential multiplier if legit (e.g., 2.0 for doubling money)
  final double rewardMultiplier;

  Offer({
    required String subject,
    required String body,
    required this.investmentCost,
    required this.isScam,
    required this.rewardMultiplier,
  }) : super(subject: subject, body: body);

  /// Method stub to calculate result
  void processOffer() {
    // To be implemented: logic to check user cash and apply isScam check
  }
}