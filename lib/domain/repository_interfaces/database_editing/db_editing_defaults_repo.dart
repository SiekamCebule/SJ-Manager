class DbEditingDefaultsRepo {
  DbEditingDefaultsRepo({
    required this.maxJumperQualitySkill,
    required this.autoPointsForTailwindMultiplier,
    required this.maxHillPoints,
    required this.maxHillTypicalWindStrength,
    required this.maxKAndHs,
    required this.maxEventSeriesPriority,
    required this.firstDate,
    required this.lastDate,
  });

  factory DbEditingDefaultsRepo.appDefault() {
    return DbEditingDefaultsRepo(
      maxJumperQualitySkill: 20,
      maxKAndHs: 10000,
      maxHillPoints: 1000,
      maxHillTypicalWindStrength: 25,
      autoPointsForTailwindMultiplier: 1.5,
      maxEventSeriesPriority: 10,
      firstDate: DateTime(1800),
      lastDate: DateTime.now().add(Duration(days: (daysInYear * 100).toInt())),
    );
  }

  final double maxJumperQualitySkill;

  final double autoPointsForTailwindMultiplier;
  final double maxHillPoints;
  final double maxHillTypicalWindStrength;
  final double maxKAndHs;

  final double maxEventSeriesPriority;

  final DateTime firstDate;
  final DateTime lastDate;
}

const daysInYear = 365.242199;
