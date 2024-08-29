import 'package:sj_manager/ui/theme/app_schemes.dart';

abstract interface class UserSettingsRepo {
  const UserSettingsRepo();

  void setAppColorScheme(AppColorScheme scheme);
  void setLanguageCode(String code);
  void setDatabaseEditorTutorialShown(bool shown);

  AppColorScheme? get appColorScheme;
  String? get languageCode;
  bool? get databaseEditorTutorialShown;
}
