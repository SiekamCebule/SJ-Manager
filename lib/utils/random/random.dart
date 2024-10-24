import 'dart:math';

double linearRandomDouble(double start, double end) {
  final random = Random();
  return start + random.nextDouble() * (end - start);
}
