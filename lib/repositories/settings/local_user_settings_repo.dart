import 'package:shared_preferences/shared_preferences.dart';
import 'package:sj_manager/repositories/settings/user_settings_repo.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

class LocalUserSettingsRepo implements UserSettingsRepo {
  const LocalUserSettingsRepo({
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  void setAppColorScheme(AppColorScheme scheme) {
    prefs.setString('colorScheme', scheme.toString());
  }

  @override
  AppColorScheme? get appColorScheme {
    final string = prefs.getString('colorScheme');
    return string != null ? AppColorScheme.fromString(string) : null;
  }

  @override
  void setDatabaseEditorTutorialShown(bool shown) {
    prefs.setString('databaseEditorTutorialShown', shown.toString());
  }

  @override
  bool? get databaseEditorTutorialShown {
    final string = prefs.getString('databaseEditorTutorialShown');
    return string != null ? bool.parse(string) : null;
  }

  @override
  void setLanguageCode(String code) {
    prefs.setString('languageCode', code);
  }

  @override
  String? get languageCode {
    return prefs.getString('languageCode');
  }
}
