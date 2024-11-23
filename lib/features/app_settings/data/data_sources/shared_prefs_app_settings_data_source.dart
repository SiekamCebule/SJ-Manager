import 'package:shared_preferences/shared_preferences.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';

abstract interface class SharedPrefsAppSettingsDataSource {
  Future<AppColorScheme> get colorScheme;
  Future<String> get languageCode;

  Future<void> setColorScheme(AppColorScheme colorScheme);
  Future<void> setLanguageCode(String languageCode);
}

class SharedPrefsAppSettingsDataSourceImpl implements SharedPrefsAppSettingsDataSource {
  const SharedPrefsAppSettingsDataSourceImpl({
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  Future<AppColorScheme> get colorScheme async =>
      AppColorScheme.fromString(prefs.getString('colorScheme')!);

  @override
  Future<String> get languageCode async => prefs.getString('languageCode')!;

  @override
  Future<void> setColorScheme(AppColorScheme colorScheme) async {
    await prefs.setString('colorScheme', colorScheme.name);
  }

  @override
  Future<void> setLanguageCode(String languageCode) async {
    await prefs.setString('languageCode', languageCode);
  }
}
