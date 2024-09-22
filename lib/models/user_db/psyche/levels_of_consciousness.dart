enum LevelsOfConsciousness {
  shame(20.0),
  guilt(30.0),
  apathy(50.0),
  grief(75.0),
  fear(100.0),
  desire(125.0),
  anger(150.0),
  pride(175.0),
  courage(200.0),
  neutrality(250.0),
  willingness(310.0),
  acceptance(350.0),
  reason(400.0),
  love(500.0),
  joy(540.0),
  peace(600.0),
  enlightenment(700.0);

  const LevelsOfConsciousness(
    this.logarithmicValue,
  );

  final double logarithmicValue;

  bool isHigherThan(LevelsOfConsciousness other) =>
      logarithmicValue > other.logarithmicValue;
  bool isEqualTo(LevelsOfConsciousness other) =>
      logarithmicValue == other.logarithmicValue;

  @override
  String toString() {
    return 'A level of consciousness with logarithmic value of $logarithmicValue';
  }
}
