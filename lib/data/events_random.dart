import '../models/randomEvent.dart';
import '../models/user.dart';

final List<RandomEvent> allRandomEvents = [
  // --- HOUSING ---
  RandomEvent(
    title: "Rent Increase",
    description: "Your landlord notifies you that rent is increasing due to rising housing costs.",
    options: [
      EventOption(label: "Accept new rent (+\$120/mo)", onSelected: (u) => u.rent += 120),
    ],
  ),
  RandomEvent(
    title: "Plumbing Emergency",
    description: "A pipe bursts in your bathroom and needs urgent repair.",
    options: [
      EventOption(label: "Pay \$350 for plumber", onSelected: (u) => u.cash -= 350),
    ],
  ),
  RandomEvent(
    title: "Electrical Issue",
    description: "Your lights keep flickering. An electrician says the wiring needs fixing.",
    options: [
      EventOption(label: "Repair wiring for \$280", onSelected: (u) => u.cash -= 280),
      EventOption(label: "Wait until next month", onSelected: (u) => u.electricalSkips++),
    ],
  ),
  RandomEvent(
    title: "Home Appliance Breaks",
    description: "Your refrigerator stops working.",
    options: [
      EventOption(label: "Replace for \$800", onSelected: (u) => u.cash -= 800),
      EventOption(label: "Repair for \$250", onSelected: (u) => u.cash -= 250),
    ],
  ),

  // --- TRANSPORTATION ---
  RandomEvent(
    title: "Buy a Car",
    description: "You’re tired of public transport and consider buying a car.",
    options: [
      EventOption(label: "Buy new car (\$900/mo)", onSelected: (u) {
        u.hasCar = true;
        u.transportation = 900;
      }),
      EventOption(label: "Buy used car (\$350/mo)", onSelected: (u) {
        u.hasCar = true;
        u.transportation = 350;
      }),
      EventOption(label: "Keep taking the bus", onSelected: (u) => null),
    ],
  ),
  RandomEvent(
    title: "Routine Car Maintenance",
    description: "Your vehicle is due for servicing.",
    options: [
      EventOption(label: "Pay \$120 for maintenance", onSelected: (u) => u.cash -= 120),
      EventOption(label: "Skip this month", onSelected: (u) => u.maintenanceSkips++),
    ],
  ),
  RandomEvent(
    title: "Car Insurance Increase",
    description: "Your car insurance premium has gone up this year.",
    options: [
      EventOption(label: "Accept increase (+\$40/mo)", onSelected: (u) => u.carInsurance += 40),
    ],
  ),

  // --- FAMILY & LIFE ---
  RandomEvent(
    title: "Partner Talks About Kids",
    description: "Your partner asks if you want to start a family.",
    options: [
      EventOption(label: "Agree to have a child", onSelected: (u) {
        u.hasKids = true;
        u.otherExpenses += 400; // Monthly cost of a child
      }),
      EventOption(label: "Not right now", onSelected: (u) => null),
    ],
  ),
  RandomEvent(
    title: "Child Medical Bill",
    description: "Your child caught the flu and needed a clinic visit.",
    options: [
      EventOption(label: "Pay \$90 medical bill", onSelected: (u) => u.cash -= 90),
    ],
  ),
  RandomEvent(
    title: "Birthday Party",
    description: "Your child wants a birthday party with friends.",
    options: [
      EventOption(label: "Host party for \$200", onSelected: (u) => u.cash -= 200),
      EventOption(label: "Small celebration at home (\$50)", onSelected: (u) => u.cash -= 50),
    ],
  ),
  RandomEvent(
    title: "Child School Trip",
    description: "Your child’s class is going on a field trip.",
    options: [
      EventOption(label: "Pay \$75", onSelected: (u) => u.cash -= 75),
      EventOption(label: "Decline", onSelected: (u) => null),
    ],
  ),

  // --- CAREER ---
  RandomEvent(
    title: "Promotion at Work",
    description: "Your manager offers you a promotion with more responsibility.",
    options: [
      EventOption(label: "Accept (+12% salary)", onSelected: (u) => u.baseSalary *= 1.12),
    ],
  ),
  RandomEvent(
    title: "Job Loss",
    description: "Your company is downsizing and your position was cut.",
    options: [
      EventOption(label: "Ok", onSelected: (u) => u.baseSalary = 0),
    ],
  ),
  RandomEvent(
    title: "New Job",
    description: "You received a job offer after applying to several positions.",
    options: [
      EventOption(label: "Accept (Set salary to \$3200)", onSelected: (u) => u.baseSalary = 3200),
      EventOption(label: "Decline offer", onSelected: (u) => null),
    ],
  ),
  RandomEvent(
    title: "Performance Bonus",
    description: "You exceeded expectations this month.",
    options: [
      EventOption(label: "Receive \$500 bonus", onSelected: (u) => u.cash += 500),
    ],
  ),

  // --- WIND FALLS ---
  RandomEvent(
    title: "Gift from Parents",
    description: "Your parents surprised you with financial help to support your goals.",
    options: [
      EventOption(label: "Accept \$300 gift", onSelected: (u) => u.cash += 300),
    ],
  ),
  RandomEvent(
    title: "Government Check",
    description: "Government support payments have been issued to help households.",
    options: [
      EventOption(label: "Receive \$600 stimulus", onSelected: (u) => u.cash += 600),
    ],
  ),
];