import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/domain/repository_interfaces/settings/user_settings_repo.dart';
import 'package:sj_manager/presentation/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/presentation/ui/theme/app_schemes.dart';
import 'package:sj_manager/presentation/ui/theme/app_theme.dart';

class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit({
    required this.settingsRepo,
  }) : super(
          const AppTheme(
            brightness: UiGlobalConstants.defaultAppThemeBrightness,
            colorScheme: UiGlobalConstants.defaultAppColorScheme,
          ),
        ) {
    _setUp();
  }

  void _setUp() {
    userSettingsSubscription = settingsRepo.stream.listen((_) {
      emit(
        AppTheme(
          brightness: settingsRepo.appThemeBrightness ?? Brightness.dark,
          colorScheme: settingsRepo.appColorScheme ?? AppColorScheme.blue,
        ),
      );
    });
  }

  final UserSettingsRepo settingsRepo;

  late final StreamSubscription<void> userSettingsSubscription;
}
