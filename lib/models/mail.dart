import 'company.dart';

abstract class Mail {
  final String subject;
  final String body;
  bool isRead;
  bool wasReadInPreviousMonth;

  Mail({
    required this.subject,
    required this.body,
    this.isRead = false,
    this.wasReadInPreviousMonth = false,
  });
}

class News extends Mail {
  final Map<Company, double> affectedCompanies;

  News({
    required super.subject,
    required super.body,
    required this.affectedCompanies,
    super.isRead,
    super.wasReadInPreviousMonth,
  });
}

class Offer extends Mail {
  final double investmentCost;
  final bool isScam;
  final double rewardMultiplier;
  final Mail? nextMail;

  Offer({
    required super.subject,
    required super.body,
    required this.investmentCost,
    required this.isScam,
    required this.rewardMultiplier,
    this.nextMail,
    super.isRead,
    super.wasReadInPreviousMonth,
  });
}

// ---------- SPECIAL MAILS ----------

final News welcomeEmail = News(
  subject: 'Welcome to your Inbox!',
  body: 'Welcome to the inbox! Here is where you will see updates about the world through a newsletter that will impact stocks for the next few months.\n\nIt is also where you can get some amazing investment opportunities... or scams! Read carefully!',
  affectedCompanies: {},
);

// ---------- SAGA FOLLOW-UPS ----------

final News ponziBusted = News(
  subject: "Financial Crime Alert: RapidWealth Circle Shut Down",
  body: "Authorities have shut down RapidWealth Circle, describing it as a large Ponzi scheme. Millions of dollars are believed to be lost.",
  affectedCompanies: {},
);

final News horizonUpdate = News(
  subject: "Monthly Portfolio Update",
  body: "Your Balanced Growth Portfolio returned 0.48% this month. The return has been deposited into your cash account.",
  affectedCompanies: {},
);

final Offer ponziFollowUp = Offer(
  subject: "Your First Profit Payment Has Arrived!",
  body: "Congratulations! Your investment is working. Reinvest \$500 now to maximize your earnings.",
  investmentCost: 500.0,
  isScam: true,
  rewardMultiplier: 2.0,
  nextMail: ponziBusted,
);

// ---------- SAGA OPENERS ----------

final Offer ponziOpening = Offer(
  subject: "Turn \$500 Into \$10,000 in Just 30 Days!",
  body: "A secret trading system guarantees massive returns. Invest \$1,500 today to secure your spot!",
  investmentCost: 1500.0,
  isScam: true,
  rewardMultiplier: 1.32,
  nextMail: ponziFollowUp,
);

final Offer horizonOpening = Offer(
  subject: "Balanced Growth Portfolio",
  body: "Steady, long-term returns. Our goal is 5-7% per year. Licensed professional management.",
  investmentCost: 2000.0,
  isScam: false,
  rewardMultiplier: 1.0048,
  nextMail: horizonUpdate,
);

final Offer nigerianPrince = Offer(
  subject: "URGENT BUSINESS ASSISTANCE",
  body: "I am a royal family member seeking helpa to transfer \$18 million. Receive 30% as a reward for your assistance.",
  investmentCost: 3000.0,
  isScam: true,
  rewardMultiplier: 0.0,
);

// ---------- WORLD EVENTS ----------

final News pandemicEvent = News(
  subject: "Global Health Advisory",
  body: "A new viral illness is spreading. Hospitals are monitoring rising numbers. Research labs are beginning vaccine studies.",
  affectedCompanies: {
    // Note: ensure these company variables are imported/available
  },
);

final News bullMarketEvent = News(
  subject: "Global Markets Rally",
  body: "Economic confidence grows as consumer spending increases worldwide.",
  affectedCompanies: {},
);

// ---------- MASTER LIST ----------

final List<Mail> potentialMails = [
  ponziOpening,
  horizonOpening,
  nigerianPrince,
  pandemicEvent,
  bullMarketEvent,
];