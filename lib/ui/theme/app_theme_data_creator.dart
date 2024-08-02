import 'package:flutter/material.dart';
import 'package:sj_manager/ui/theme/app_theme.dart';

class AppThemeDataCreator {
  late AppTheme _themeConfig;
  late ThemeData _themeData;

  ThemeData create(AppTheme appTheme) {
    _themeConfig = appTheme;
    _themeData = ThemeData.from(
      colorScheme: _themeConfig.colorScheme.scheme(_themeConfig.brightness),
    );
    _themeData =
        _themeData.copyWith(textTheme: _constructTextTheme(_themeData.textTheme));
    _themeData =
        _themeData.copyWith(dialogTheme: _constructDialogTheme(_themeData.dialogTheme));
    return _themeData;
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
        fontWeight: FontWeight.w300,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w300,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  DialogTheme _constructDialogTheme(DialogTheme base) {
    return base.copyWith(
      contentTextStyle:
          _themeData.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w300),
    );
  }
}
