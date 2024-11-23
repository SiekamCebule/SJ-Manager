import 'package:sj_manager/features/app_settings/data/data_sources/shared_prefs_app_settings_data_source.dart';
import 'package:sj_manager/features/app_settings/domain/repository/app_settings_repository.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';

class LocalAppSettingsRepository implements AppSettingsRepository {
  LocalAppSettingsRepository({
    required this.settingsDataSource,
  });

  final SharedPrefsAppSettingsDataSource settingsDataSource;

  @override
  Future<AppColorScheme> get colorScheme async => await settingsDataSource.colorScheme;

  @override
  Future<String> get languageCode async => await settingsDataSource.languageCode;

  @override
  Future<void> setColorScheme(AppColorScheme colorScheme) async {
    await settingsDataSource.setColorScheme(colorScheme);
  }

  @override
  Future<void> setLanguageCode(String languageCode) async {
    await settingsDataSource.setLanguageCode(languageCode);
  }
}
