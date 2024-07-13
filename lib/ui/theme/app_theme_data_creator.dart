import 'package:flutter/material.dart';
import 'package:sj_manager/ui/theme/app_theme.dart';

class AppThemeDataCreator {
  late AppTheme _themeConfig;

  ThemeData create(AppTheme appTheme) {
    _themeConfig = appTheme;
    var themeData = ThemeData.from(
      colorScheme: _themeConfig.colorScheme.scheme(_themeConfig.brightness),
    );
    final base = themeData.textTheme;
    final textTheme = _constructTextTheme(base);
    themeData = themeData.copyWith(textTheme: textTheme);
    return themeData;
  }

  TextTheme _constructTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
