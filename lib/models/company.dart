// company.dart
import 'dart:math';

enum RiskLevel { low, medium, high }

class Company {
  final String name;          // Company name
  final String sector;        // Industry sector
  final String description;   // Short description
  final String longDescription; // Detailed description
  final RiskLevel risk;       // Hidden risk level

  double price;               // Current stock price
  int owned;                  // How many stocks the user owns
  bool goingUp;               // Price trend for UI

  double probabilityModifier; // Extra probability to go up or down
  List<double> priceHistory;  // Stores past prices
  double lastChangePercent;   // Percent change from last month

  final Random _random = Random();

  Company({
    required this.name,
    required this.sector,
    required this.description,
    required this.longDescription,
    this.risk = RiskLevel.medium,
    this.price = 50,
    this.owned = 0,
    this.goingUp = true,
    this.probabilityModifier = 0.0,
    List<double>? initialPriceHistory,
  }) : 
        priceHistory = initialPriceHistory ??
            [
              double.parse(
                (price * (1 + _getInitialFluctuation(risk, Random()))).toStringAsFixed(2),
              )
            ],
        lastChangePercent = 0.0;

  static double _getInitialFluctuation(RiskLevel risk, Random random) {
    double maxFluctuation;
    switch (risk) {
      case RiskLevel.low:
        maxFluctuation = 0.03;
        break;
      case RiskLevel.medium:
        maxFluctuation = 0.07;
        break;
      case RiskLevel.high:
        maxFluctuation = 0.15;
        break;
    }
    return random.nextDouble() * 2 * maxFluctuation - maxFluctuation;
  }

  void updateProbability(double change) {
    probabilityModifier += change;
    probabilityModifier = probabilityModifier.clamp(-1.0, 1.0);
  }

  void updatePrice() {
    priceHistory.insert(0, price);

    double baseProbability;
    switch (risk) {
      case RiskLevel.low:
        baseProbability = 0.55;
        break;
      case RiskLevel.medium:
        baseProbability = 0.5;
        break;
      case RiskLevel.high:
        baseProbability = 0.45;
        break;
    }

    double finalProbability = (baseProbability + probabilityModifier).clamp(0.0, 1.0);
    goingUp = _random.nextDouble() < finalProbability;

    double volatility;
    switch (risk) {
      case RiskLevel.low:
        volatility = 0.03;
        break;
      case RiskLevel.medium:
        volatility = 0.07;
        break;
      case RiskLevel.high:
        volatility = 0.15;
        break;
    }

    double changePercent = _random.nextDouble() * volatility;
    double oldPrice = price;
    price *= goingUp ? (1 + changePercent) : (1 - changePercent);
    price = double.parse(price.toStringAsFixed(2));

    if (priceHistory.isNotEmpty) {
      lastChangePercent = ((price - priceHistory.first) / priceHistory.first) * 100;
      lastChangePercent = double.parse(lastChangePercent.toStringAsFixed(2));
    } else {
      lastChangePercent = 0.0;
    }
  }
}

// ---------- Global Company List ----------
final List<Company> companies = [
  Company(
    name: 'BrightPulse Clinics',
    sector: 'Medical',
    description: 'A network of small neighborhood health centers.',
    longDescription: 'BrightPulse runs many small health centers in neighborhoods. Their main income comes from regular doctor visits, vaccines, and basic treatments. Because people always need healthcare, their revenue is steady and slowly growing. Most of their costs are staff salaries and medical supplies. They have some loans from opening new clinics, but debt is manageable. Their success depends on local populations and healthcare funding.',
    risk: RiskLevel.low,
  ),
  Company(
    name: 'ViraCure Biolabs',
    sector: 'Medical Research',
    description: 'Studies viruses to develop medicines and vaccines.',
    longDescription: 'ViraCure researches viruses and tries to make medicines and vaccines. Research is expensive and takes years. They earn money from government grants and deals with large drug companies. Income can jump if a new medicine succeeds, but they often spend more than they earn. They have moderate debt from labs and equipment. Their future depends on successful discoveries and approvals.',
    risk: RiskLevel.high,
  ),
  Company(
    name: 'QuickGrow Research',
    sector: 'Research',
    description: 'Improves crops so farmers can grow more food with less water.',
    longDescription: 'QuickGrow develops crops that need less water. They earn money by selling improved seeds and research licenses to farming companies. Demand is growing due to climate change. Income is increasing but depends on farming seasons. They have low debt and rely on science teams and weather trends. Bad crop years can reduce sales.',
    risk: RiskLevel.medium,
  ),
  Company(
    name: 'PixelTrail Studios',
    sector: 'Technology',
    description: 'Designs and develops video games for computers and consoles.',
    longDescription: 'PixelTrail makes video games. Their money comes from game sales and in-game purchases. Revenue changes depending on whether a game is popular. Some years they earn a lot, other years less. Development costs are high, but they have little debt. Success depends on trends and player reviews.',
    risk: RiskLevel.high,
  ),
  Company(
    name: 'SafeLink Cyber',
    sector: 'Technology',
    description: 'Develops software to protect computers and phones from hackers.',
    longDescription: 'SafeLink sells protection software to companies and families. Since cyber threats are rising, demand is strong. They earn steady subscription fees. Costs include engineers and software updates. Revenue is growing and debt is low. Their biggest risk is competition and keeping up with new threats.',
    risk: RiskLevel.low,
  ),
  Company(
    name: 'HomeBot Innovations',
    sector: 'Technology',
    description: 'Builds small robots for household chores.',
    longDescription: 'HomeBot builds helper robots. Products are popular but expensive to make. Sales are growing, but profits are small because research and parts cost a lot. They borrowed money to build factories, so debt is high. Their future depends on technology improvements and consumer interest.',
    risk: RiskLevel.high,
  ),
  Company(
    name: 'StoneBridge Builders',
    sector: 'Construction',
    description: 'Builds houses, schools, and small office buildings.',
    longDescription: 'StoneBridge builds homes and public buildings. They earn money from construction contracts. Income depends on the housing market and government projects. Revenue is stable but can drop during economic slowdowns. Equipment and worker wages are major costs. They carry moderate debt for machinery.',
    risk: RiskLevel.medium,
  ),
  Company(
    name: 'GreenFrame Construction',
    sector: 'Construction',
    description: 'Focuses on eco-friendly buildings.',
    longDescription: 'GreenFrame builds energy-saving buildings. More cities want green construction, so demand is rising. Materials cost more, but customers pay higher prices. Revenue is growing steadily. Debt is moderate due to specialized tools. Success depends on environmental laws and eco-friendly trends.',
    risk: RiskLevel.medium,
  ),
  Company(
    name: 'SilverStream Resources',
    sector: 'Natural Resources',
    description: 'Extracts useful minerals for electronics.',
    longDescription: 'SilverStream mines minerals used in electronics. Income depends on global demand for phones and computers. Prices for minerals can change quickly. Mining equipment is expensive, and they have high operating costs. They have some debt from heavy machinery. Environmental rules can also affect profits.',
    risk: RiskLevel.high,
  ),
  Company(
    name: 'EarthCore Aggregates',
    sector: 'Natural Resources',
    description: 'Provides sand, gravel, and stone for construction.',
    longDescription: 'EarthCore sells sand, gravel, and stone for construction. These materials are always needed for roads and buildings. Revenue is steady but not fast-growing. Costs include trucks and mining equipment. Debt is low. Business depends on local construction activity.',
    risk: RiskLevel.low,
  ),
  Company(
    name: 'WindWay Power',
    sector: 'Energy',
    description: 'Runs wind farms that generate electricity.',
    longDescription: 'WindWay runs wind farms and sells electricity. Income comes from long-term contracts with towns. Revenue is stable and growing as clean energy demand rises. Turbines are expensive, so debt is moderate. Weather affects short-term output, but overall income is predictable.',
    risk: RiskLevel.low,
  ),
  Company(
    name: 'CoalCore Energy',
    sector: 'Energy',
    description: 'Generates electricity by burning coal and other fossil fuels.',
    longDescription: 'CoalCore produces electricity from coal. It earns steady income from power sales. However, pollution rules and the move to clean energy are reducing demand. Costs include fuel and plant maintenance. They have high debt from large power plants. They are significantly impacted by changing government regulations.',
    risk: RiskLevel.high,
  ),
  Company(
    name: 'AquaPure Filters',
    sector: 'Water Treatment',
    description: 'Makes systems that clean dirty water.',
    longDescription: 'AquaPure makes water cleaning systems. Customers include cities and factories. Clean water is always needed, so demand is stable. Revenue grows slowly. Manufacturing equipment is costly, but debt is manageable. Business depends on water safety rules and infrastructure spending.',
    risk: RiskLevel.medium,
  ),
  Company(
    name: 'CozyNest Furniture',
    sector: 'Manufacturing',
    description: 'Designs and builds simple, comfortable home furniture.',
    longDescription: 'CozyNest makes home furniture. Sales rise when people buy new homes but drop during recessions. Materials and factory workers are the main costs. Revenue changes with the economy. They have moderate loans for factories.',
    risk: RiskLevel.low,
  ),
  Company(
    name: 'TrailGuard Gear',
    sector: 'Outdoor Equipment',
    description: 'Makes backpacks, tents, and camping tools.',
    longDescription: 'TrailGuard sells camping and hiking gear. Sales grow during travel seasons. Revenue can vary depending on trends and weather. Production costs are moderate, and debt is low. Business depends on tourism and outdoor interest.',
    risk: RiskLevel.medium,
  ),
  Company(
    name: 'BrightSign Printing',
    sector: 'Printing Services',
    description: 'Prints posters, signs, and books for schools and businesses.',
    longDescription: 'BrightSign prints signs and books. Many customers are schools and businesses. However, more people use digital media, so demand is slowly declining. Equipment is costly but mostly paid off. Revenue is stable but shrinking over time.',
    risk: RiskLevel.medium,
  ),
  Company(
    name: 'CityCycle Repair',
    sector: 'Bicycle Services',
    description: 'Fixes bikes and sells parts and safety gear.',
    longDescription: 'CityCycle fixes bikes and sells parts. Income comes from repairs and gear sales. Demand rises in warm months. Revenue is stable but small. They have very little debt. Business depends on local biking popularity.',
    risk: RiskLevel.low,
  ),
  Company(
    name: 'PetalPatch Gardens',
    sector: 'Landscaping',
    description: 'Plants and maintains gardens and green spaces.',
    longDescription: 'PetalPatch designs and maintains gardens. Customers include homes and offices. Work is seasonal, with more income in spring and summer. Costs are tools and workers. Revenue is steady but not large. Debt is very low.',
    risk: RiskLevel.low,
  ),
  Company(
    name: 'NumberNest Accounting',
    sector: 'Finance',
    description: 'Helps people and small businesses manage money and taxes.',
    longDescription: 'NumberNest helps people and small businesses manage money and taxes. They earn fees for services. Demand is steady, especially during tax season. Costs are mainly staff salaries. Revenue is stable and slowly growing. Debt is very low.',
    risk: RiskLevel.low,
  ),
  Company(
    name: 'FusionSpring Energy',
    sector: 'Energy',
    description: 'Trying to create clean energy using nuclear fusion.',
    longDescription: 'FusionSpring is working on fusion reactors that could one day produce huge amounts of clean energy. Fusion power has never been commercially successful yet. The company spends large amounts on scientists, rare materials, and complex machines. They have no steady revenue and depend fully on investors and government funding. Debt is high, and progress can be slow or uncertain. If they succeed, the payoff could be enormous, but failure is also possible.',
    risk: RiskLevel.high,
  ),
  Company(
    name: 'NeuroWeave Interfaces',
    sector: 'Technology',
    description: 'Develops devices that connect the human brain directly to computers.',
    longDescription: 'NeuroWeave is building brain–computer interface (BCI) implants and headsets. The idea is promising for medical use, like helping paralyzed patients move devices, but the technology is still experimental. They currently earn almost no sales revenue and rely on investor funding and research grants. Costs are extremely high due to labs, testing, and safety trials. They carry heavy debt and must pass strict health regulations before selling products. They have long-term speculative potential.',
    risk: RiskLevel.high,
  ),
  Company(
    name: 'HoloLife Systems',
    sector: 'Augmented Reality Platforms',
    description: 'Creates advanced AR glasses for work, school, and entertainment.',
    longDescription: 'HoloLife builds lightweight augmented reality glasses and software. Interest in AR is growing, and some companies are testing the technology for training and design. Revenue exists but is still small compared to costs. They earn from early business clients, not regular consumers yet. Research, hardware production, and software development are expensive, leading to moderate debt. The technology is likely to stay important, but designs must improve before mass adoption. If they adapt well, they could grow steadily; if not, competitors may overtake them.',
    risk: RiskLevel.medium,
  ),
];
