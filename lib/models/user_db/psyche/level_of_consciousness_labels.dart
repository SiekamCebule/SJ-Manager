enum LevelOfConsciousnessLabels {
  shame,
  guilt,
  apathy,
  grief,
  fear,
  desire,
  anger,
  pride,
  courage,
  neutrality,
  willingness,
  acceptance,
  reason,
  love,
  joy,
  peace,
  enlightenment
}

const Map<LevelOfConsciousnessLabels, double> levelOfConsciousnessLog = {
  LevelOfConsciousnessLabels.shame: 20.0,
  LevelOfConsciousnessLabels.guilt: 30.0,
  LevelOfConsciousnessLabels.apathy: 50.0,
  LevelOfConsciousnessLabels.grief: 75.0,
  LevelOfConsciousnessLabels.fear: 100.0,
  LevelOfConsciousnessLabels.desire: 125.0,
  LevelOfConsciousnessLabels.anger: 150.0,
  LevelOfConsciousnessLabels.pride: 175.0,
  LevelOfConsciousnessLabels.courage: 200.0,
  LevelOfConsciousnessLabels.neutrality: 250.0,
  LevelOfConsciousnessLabels.willingness: 310.0,
  LevelOfConsciousnessLabels.acceptance: 350.0,
  LevelOfConsciousnessLabels.reason: 400.0,
  LevelOfConsciousnessLabels.love: 500.0,
  LevelOfConsciousnessLabels.joy: 540.0,
  LevelOfConsciousnessLabels.peace: 600.0,
  LevelOfConsciousnessLabels.enlightenment: 700.0,
};

class LevelOfConsciousness {
  const LevelOfConsciousness(
    this.logarithmicValue,
  );

  LevelOfConsciousness.fromMapOfConsciousness(LevelOfConsciousnessLabels label)
      : logarithmicValue = levelOfConsciousnessLog[label]!;

  final double logarithmicValue;
  LevelOfConsciousnessLabels get label {
    return levelOfConsciousnessLog.entries
        .firstWhere((entry) => entry.value == logarithmicValue)
        .key;
  }

  bool isHigherThan(LevelOfConsciousness other) =>
      logarithmicValue > other.logarithmicValue;
  bool isEqualTo(LevelOfConsciousness other) =>
      logarithmicValue == other.logarithmicValue;

  @override
  String toString() {
    return 'A level of consciousness with logarithmic value of $logarithmicValue';
  }
}
