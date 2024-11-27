import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sj_manager/features/app_settings/domain/use_cases/get_app_color_scheme_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/get_app_language_code_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/set_app_color_scheme_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/set_app_language_code_use_case.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit({
    required this.setColorScheme,
    required this.setLanguageCode,
    required this.getColorScheme,
    required this.getLanguageCode,
  }) : super(const AppSettingsInitial());

  final SetAppColorSchemeUseCase setColorScheme;
  final SetAppLanguageCodeUseCase setLanguageCode;
  final GetAppColorSchemeUseCase getColorScheme;
  final GetAppLanguageCodeUseCase getLanguageCode;

  Future<void> initialize() async {
    emit(AppSettingsInitialized(
      colorScheme: await getColorScheme(),
      languageCode: await getLanguageCode(),
    ));
  }

  Future<void> setLanguageCode(String languageCode) async {
    await setLanguageCode(languageCode);
    emit((state as AppSettingsInitialized).copyWith(
      languageCode: await getLanguageCode(),
    ));
  }

  Future<void> setColorScheme(AppColorScheme colorScheme) async {
    await setColorScheme(colorScheme);
    emit((state as AppSettingsInitialized).copyWith(
      colorScheme: await getColorScheme(),
    ));
  }
}

abstract class AppSettingsState extends Equatable {
  const AppSettingsState();

  @override
  List<Object?> get props => [];
}

class AppSettingsInitial extends AppSettingsState {
  const AppSettingsInitial();
}

class AppSettingsInitialized extends AppSettingsState {
  const AppSettingsInitialized({
    required this.colorScheme,
    required this.languageCode,
  });

  final AppColorScheme colorScheme;
  final String languageCode;

  @override
  List<Object?> get props => [
        colorScheme,
        languageCode,
      ];

  AppSettingsInitialized copyWith({
    AppColorScheme? colorScheme,
    String? languageCode,
  }) {
    return AppSettingsInitialized(
      colorScheme: colorScheme ?? this.colorScheme,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
