import 'dart:math';

double averageDirection(List<double> angles, List<double> weights) {
  if (angles.isEmpty || angles.length != weights.length) {
    throw ArgumentError("Angles and weights must be non-empty and of the same length.");
  }

  double sumSin = 0;
  double sumCos = 0;

  for (int i = 0; i < angles.length; i++) {
    double angle = angles[i];
    double weight = weights[i];
    sumSin += sin(angle * pi / 180) * weight;
    sumCos += cos(angle * pi / 180) * weight;
  }

  double avgAngle = atan2(sumSin, sumCos) * 180 / pi;

  if (avgAngle < 0) {
    avgAngle += 360;
  }

  return avgAngle;
}

double averageDirectionWeightedForLast(
  List<double> angles, {
  required double lastWeight,
}) {
  return averageDirection(angles, [
    ...List.generate(angles.length - 1, (_) => 1.0),
    lastWeight,
  ]);
}
