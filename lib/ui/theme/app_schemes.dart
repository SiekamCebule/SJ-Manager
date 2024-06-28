import 'package:flutter/material.dart';

enum AppColorScheme {
  blue,
  yellow,
  red;

  ColorScheme scheme(Brightness brightness) {
    return brightness == Brightness.light
        ? appLightSchemes[this]!
        : appDarkSchemes[this]!;
  }
}

final appLightSchemes = {
  AppColorScheme.blue: ColorScheme.fromSeed(
    seedColor: Colors.lightBlue[300]!,
  ),
  AppColorScheme.yellow: ColorScheme.fromSeed(
    seedColor: Colors.yellow,
  ),
  AppColorScheme.red: ColorScheme.fromSeed(
    seedColor: Colors.red,
  ),
};

final appDarkSchemes = {
  AppColorScheme.blue: ColorScheme.fromSeed(
    seedColor: Colors.lightBlue[200]!,
    brightness: Brightness.dark,
  ),
  AppColorScheme.yellow: ColorScheme.fromSeed(
    seedColor: Colors.yellow,
    brightness: Brightness.dark,
  ),
  AppColorScheme.red: ColorScheme.fromSeed(
    seedColor: Colors.red[500]!,
    brightness: Brightness.dark,
  ),
};
