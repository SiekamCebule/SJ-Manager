import 'dart:math';

double averageDirection(List<double> angles, double divider) {
  if (divider == 0) {
    throw ArgumentError("Divider cannot be zero.");
  }

  double sumSin = 0;
  double sumCos = 0;

  for (var angle in angles) {
    sumSin += sin(angle * pi / 180);
    sumCos += cos(angle * pi / 180);
  }

  double avgAngle = atan2(sumSin / divider, sumCos / divider) * 180 / pi;

  // Convert to range 0°-360°
  if (avgAngle < 0) {
    avgAngle += 360;
  }

  return avgAngle;
}
