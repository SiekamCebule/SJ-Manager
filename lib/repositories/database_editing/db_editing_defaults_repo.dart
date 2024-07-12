class DbEditingDefaultsRepo {
  DbEditingDefaultsRepo({
    required this.maxJumperQualitySkill,
    required this.maxJumperAge,
    required this.autoPointsForTailwindMultiplier,
    required this.maxHillPoints,
    required this.maxHillTypicalWindStrength,
    required this.maxKAndHs,
  });

  final double maxJumperQualitySkill;
  final double maxJumperAge;

  final double autoPointsForTailwindMultiplier;
  final double maxHillPoints;
  final double maxHillTypicalWindStrength;
  final double maxKAndHs;
}
