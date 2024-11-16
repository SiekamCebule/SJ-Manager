import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/domain/repository_interfaces/settings/user_settings_repo.dart';
import 'package:sj_manager/presentation/ui/theme/app_schemes.dart';

class MockedUserSettingsRepo implements UserSettingsRepo {
  const MockedUserSettingsRepo({
    required this.appColorScheme,
    required this.appThemeBrightness,
    required this.databaseEditorTutorialShown,
    required this.languageCode,
  });

  @override
  final AppColorScheme appColorScheme;

  @override
  final Brightness appThemeBrightness;

  @override
  final bool databaseEditorTutorialShown;

  @override
  final String languageCode;

  @override
  void setAppColorScheme(AppColorScheme scheme) {
    throw UnimplementedError();
  }

  @override
  void setAppThemeBrightness(Brightness brightness) {
    throw UnimplementedError();
  }

  @override
  void setDatabaseEditorTutorialShown(bool shown) {
    throw UnimplementedError();
  }

  @override
  void setLanguageCode(String code) {
    throw UnimplementedError();
  }

  @override
  Stream<void> get stream => NeverStream();
}
