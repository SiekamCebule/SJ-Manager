import 'dart:math';

double roundToNDecimalPlaces(double value, int n) {
  final factor = pow(10, n);
  return (value * factor).round() / factor;
}

double weightedAverage(List<double> values, List<double> weights) {
  if (values.isEmpty || values.length != weights.length) {
    throw ArgumentError("Values and weights must be non-empty and of the same length.");
  }

  double weightedSum = 0;
  double totalWeight = 0;

  for (int i = 0; i < values.length; i++) {
    weightedSum += values[i] * weights[i];
    totalWeight += weights[i];
  }

  return weightedSum / totalWeight;
}
