import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';

abstract interface class AppSettingsRepository {
  Future<AppColorScheme> get colorScheme;
  Future<String> get languageCode;

  Future<void> setColorScheme(AppColorScheme colorScheme);
  Future<void> setLanguageCode(String languageCode);
}
