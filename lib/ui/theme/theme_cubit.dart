import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit({
    required this.appSchemeSubscription,
    required this.appThemeBrightnessSubscription,
  }) : super(
          _defaultTheme,
        ) {
    appSchemeSubscription.onData((scheme) {
      _lastScheme = scheme;
      emit(_constructTheme(scheme, _lastBrightness));
    });
    appThemeBrightnessSubscription.onData((brightness) {
      _lastBrightness = brightness;
      emit(_constructTheme(_lastScheme, brightness));
    });
  }

  final StreamSubscription<AppColorScheme> appSchemeSubscription;
  final StreamSubscription<Brightness> appThemeBrightnessSubscription;

  AppColorScheme _lastScheme = UiGlobalConstants.defaultAppColorScheme;
  Brightness _lastBrightness = UiGlobalConstants.defaultAppThemeBrightness;

  static ThemeData get _defaultTheme {
    return _constructTheme(
      UiGlobalConstants.defaultAppColorScheme,
      UiGlobalConstants.defaultAppThemeBrightness,
    );
  }

  static ThemeData _constructTheme(AppColorScheme scheme, Brightness brightness) {
    return ThemeData.from(
      colorScheme: scheme.scheme(brightness),
    );
  }
}
