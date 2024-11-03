import 'dart:math';

double linearRandomDouble(num start, num end) {
  final random = Random();
  return start + random.nextDouble() * (end - start);
}

double laplaceDistributionRandom(double mean, double scale) {
  final random = Random();
  final u = random.nextDouble() - 0.5; // Zakres od -0.5 do 0.5
  return mean - scale * (u < 0 ? log(1 + 2 * u) : -log(1 - 2 * u));
}

double cauchyDistributionRandom(double mean, double scale) {
  final random = Random();
  final normalPart1 =
      sqrt(-2 * log(random.nextDouble())) * cos(2 * pi * random.nextDouble());
  final normalPart2 =
      sqrt(-2 * log(random.nextDouble())) * cos(2 * pi * random.nextDouble());
  return mean + scale * (normalPart1 / normalPart2);
}

double dampedCauchyDistributionRandom(double mean, double scale, double dampingFactor) {
  double cauchyValue = cauchyDistributionRandom(mean, scale);

  cauchyValue *= 1 / (1 + dampingFactor * pow(cauchyValue.abs(), 2));

  return cauchyValue;
}
