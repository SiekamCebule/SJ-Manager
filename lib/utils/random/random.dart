import 'dart:math';

double linearRandomDouble(num start, num end, {int? seed}) {
  final random = Random(seed);
  return start + random.nextDouble() * (end - start);
}

double laplaceDistributionRandom(double mean, double scale, {int? seed}) {
  final random = Random(seed);
  final u = random.nextDouble() - 0.5; // Zakres od -0.5 do 0.5
  return mean - scale * (u < 0 ? log(1 + 2 * u) : -log(1 - 2 * u));
}

double cauchyDistributionRandom(double mean, double scale, {int? seed}) {
  final random = Random(seed);
  final normalPart1 =
      sqrt(-2 * log(random.nextDouble())) * cos(2 * pi * random.nextDouble());
  final normalPart2 =
      sqrt(-2 * log(random.nextDouble())) * cos(2 * pi * random.nextDouble());
  return mean + scale * (normalPart1 / normalPart2);
}

double dampedCauchyDistributionRandom(double mean, double scale, double dampingFactor,
    {int? seed}) {
  double cauchyValue = cauchyDistributionRandom(mean, scale, seed: seed);

  cauchyValue *= 1 / (1 + dampingFactor * pow(cauchyValue.abs(), 2));

  return cauchyValue;
}
