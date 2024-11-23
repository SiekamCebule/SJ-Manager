import 'package:sj_manager/features/app_settings/domain/repository/app_settings_repository.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';

class SetAppColorSchemeUseCase {
  const SetAppColorSchemeUseCase({
    required this.settingsRepository,
  });

  final AppSettingsRepository settingsRepository;

  Future<void> call(AppColorScheme colorScheme) async {
    await settingsRepository.setColorScheme(colorScheme);
  }
}
