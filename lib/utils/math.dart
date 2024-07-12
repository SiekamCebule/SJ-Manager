import 'dart:math';

double roundToNDecimalPlaces(double value, int n) {
  final factor = pow(10, n);
  return (value * factor).round() / factor;
}
