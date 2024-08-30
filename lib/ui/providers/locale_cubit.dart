import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/repositories/settings/user_settings_repo.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit({
    required this.settingsRepo,
    Locale? initial,
  }) : super(initial ?? const Locale('en')) {
    if (initial == null) {
      load();
    }
  }

  final UserSettingsRepo settingsRepo;

  Future<void> load() async {
    final languageCodeFromRepo = settingsRepo.languageCode;
    if (languageCodeFromRepo != null) {
      emit(Locale(languageCodeFromRepo));
      return;
    }
    final langaugeCodeFromDevice =
        PlatformDispatcher.instance.locale.languageCode.substring(0, 2);
    emit(Locale(langaugeCodeFromDevice));
    settingsRepo.setLanguageCode(langaugeCodeFromDevice);
  }

  Future<void> update(Locale locale) async {
    emit(locale);
    settingsRepo.setLanguageCode(languageCode.substring(0, 2));
  }

  String get languageCode => state.languageCode;
}
