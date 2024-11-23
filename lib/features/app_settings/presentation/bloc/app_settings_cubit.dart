import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sj_manager/features/app_settings/domain/use_cases/get_app_color_scheme_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/get_app_language_code_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/set_app_color_scheme_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/set_app_language_code_use_case.dart';
import 'package:sj_manager/to_embrace/ui/theme/app_schemes.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit({
    required this.setColorSchemeUseCase,
    required this.setLanguageCodeUseCase,
    required this.getColorSchemeUseCase,
    required this.getLanguageCodeUseCase,
  }) : super(const AppSettingsInitial());

  final SetAppColorSchemeUseCase setColorSchemeUseCase;
  final SetAppLanguageCodeUseCase setLanguageCodeUseCase;
  final GetAppColorSchemeUseCase getColorSchemeUseCase;
  final GetAppLanguageCodeUseCase getLanguageCodeUseCase;

  Future<void> initialize() async {
    emit(AppSettingsInitialized(
      colorScheme: await getColorSchemeUseCase(),
      languageCode: await getLanguageCodeUseCase(),
    ));
  }

  Future<void> setLanguageCode(String languageCode) async {
    await setLanguageCodeUseCase(languageCode);
    emit((state as AppSettingsInitialized).copyWith(
      languageCode: await getLanguageCodeUseCase(),
    ));
  }

  Future<void> setColorScheme(AppColorScheme colorScheme) async {
    await setColorSchemeUseCase(colorScheme);
    emit((state as AppSettingsInitialized).copyWith(
      colorScheme: await getColorSchemeUseCase(),
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
