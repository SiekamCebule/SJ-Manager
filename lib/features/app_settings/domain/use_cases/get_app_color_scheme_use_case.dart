import 'package:sj_manager/features/app_settings/domain/repository/app_settings_repository.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';

class GetAppColorSchemeUseCase {
  const GetAppColorSchemeUseCase({
    required this.settingsRepository,
  });

  final AppSettingsRepository settingsRepository;

  Future<AppColorScheme> call() async {
    return settingsRepository.colorScheme;
  }
}
