class DbEditingDefaultsRepo {
  DbEditingDefaultsRepo({
    required this.maxJumperQualitySkill,
    required this.maxJumperAge,
    required this.autoPointsForTailwindMultiplier,
    required this.maxHillPoints,
    required this.maxHillTypicalWindStrength,
    required this.maxKAndHs,
  });

  factory DbEditingDefaultsRepo.appDefault() {
    return DbEditingDefaultsRepo(
      maxJumperQualitySkill: 100,
      maxJumperAge: 99,
      maxKAndHs: 10000,
      maxHillPoints: 1000,
      maxHillTypicalWindStrength: 25,
      autoPointsForTailwindMultiplier: 1.5,
    );
  }

  final double maxJumperQualitySkill;
  final double maxJumperAge;

  final double autoPointsForTailwindMultiplier;
  final double maxHillPoints;
  final double maxHillTypicalWindStrength;
  final double maxKAndHs;
}
