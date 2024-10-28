import 'dart:math';

double linearRandomDouble(num start, num end) {
  final random = Random();
  return start + random.nextDouble() * (end - start);
}
