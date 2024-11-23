import 'package:sj_manager/features/app_settings/domain/repository/app_settings_repository.dart';

class SetAppLanguageCodeUseCase {
  const SetAppLanguageCodeUseCase({
    required this.settingsRepository,
  });

  final AppSettingsRepository settingsRepository;

  Future<void> call(String languageCode) async {
    await settingsRepository.setLanguageCode(languageCode);
  }
}
