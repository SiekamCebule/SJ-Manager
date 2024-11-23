import 'package:flutter/material.dart';

Color blendColorWithBg(
  Color color, {
  required Brightness brightness,
  required double amount,
}) {
  final hsl = HSLColor.fromColor(color);
  final hslAdjusted = brightness == Brightness.dark
      ? hsl.withLightness(
          (hsl.lightness + (amount < 0 ? -amount : -amount)).clamp(0.0, 1.0))
      : hsl.withLightness(
          (hsl.lightness + (amount < 0 ? amount : amount)).clamp(0.0, 1.0));
  return hslAdjusted.toColor();
}

extension BlendColorWithBackground on Color {
  Color blendWithBg(Brightness brightness, double amount) {
    return blendColorWithBg(this, brightness: brightness, amount: amount);
  }
}
