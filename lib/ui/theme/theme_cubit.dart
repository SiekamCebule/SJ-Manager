import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/theme/app_color_scheme_repo.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';
import 'package:sj_manager/ui/theme/app_theme.dart';
import 'package:sj_manager/ui/theme/app_theme_brightness_repo.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit({
    required this.colorSchemeRepo,
    required this.brightnessRepo,
  }) : super(
          const AppTheme(
              brightness: UiGlobalConstants.defaultAppThemeBrightness,
              colorScheme: UiGlobalConstants.defaultAppColorScheme),
        ) {
    _setUp();
  }

  void _setUp() {
    appSchemeSubscription = colorSchemeRepo.values.listen((scheme) {
      emit(
        AppTheme(brightness: state.brightness, colorScheme: scheme),
      );
    });
    appThemeBrightnessSubscription = brightnessRepo.values.listen((brightness) {
      emit(
        AppTheme(brightness: brightness, colorScheme: state.colorScheme),
      );
    });
  }

  void dispose() {
    colorSchemeRepo.dispose();
    brightnessRepo.dipose();
  }

  final AppColorSchemeRepo colorSchemeRepo;
  final AppThemeBrightnessRepo brightnessRepo;

  late final StreamSubscription<AppColorScheme> appSchemeSubscription;
  late final StreamSubscription<Brightness> appThemeBrightnessSubscription;
}
