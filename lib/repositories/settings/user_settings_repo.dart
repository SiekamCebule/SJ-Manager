import 'package:flutter/services.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

abstract interface class UserSettingsRepo {
  UserSettingsRepo();

  void setAppColorScheme(AppColorScheme scheme);
  void setAppThemeBrightness(Brightness brightness);
  void setLanguageCode(String code);
  void setDatabaseEditorTutorialShown(bool shown);

  AppColorScheme? get appColorScheme;
  Brightness? get appThemeBrightness;
  String? get languageCode;
  bool? get databaseEditorTutorialShown;

  Stream<void> get stream;
}
