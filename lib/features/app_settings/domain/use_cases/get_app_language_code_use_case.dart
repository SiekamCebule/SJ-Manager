import 'package:sj_manager/features/app_settings/domain/repository/app_settings_repository.dart';

class GetAppLanguageCodeUseCase {
  const GetAppLanguageCodeUseCase({
    required this.settingsRepository,
  });

  final AppSettingsRepository settingsRepository;

  Future<String> call() async {
    return settingsRepository.languageCode;
  }
}
