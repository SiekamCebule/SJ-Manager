import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sj_manager/repositories/settings/user_settings_repo.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';
import 'package:collection/collection.dart';

class LocalUserSettingsRepo implements UserSettingsRepo {
  LocalUserSettingsRepo({
    required this.prefs,
  });

  final SharedPreferences prefs;
  final _subject = BehaviorSubject<void>.seeded(null);

  @override
  void setAppColorScheme(AppColorScheme scheme) {
    prefs.setString('colorScheme', scheme.name.toString());
    _notify();
  }

  @override
  AppColorScheme? get appColorScheme {
    final string = prefs.getString('colorScheme');
    return string != null ? AppColorScheme.fromString(string) : null;
  }

  @override
  void setAppThemeBrightness(Brightness brightness) {
    prefs.setString('themeBrigthness', brightness.name.toString());
    _notify();
  }

  @override
  Brightness? get appThemeBrightness {
    final string = prefs.getString('themeBrigthness');
    return Brightness.values.singleWhereOrNull((brigthness) => brigthness.name == string);
  }

  @override
  void setDatabaseEditorTutorialShown(bool shown) {
    prefs.setString('databaseEditorTutorialShown', shown.toString());
    _notify();
  }

  @override
  bool? get databaseEditorTutorialShown {
    final string = prefs.getString('databaseEditorTutorialShown');
    return string != null ? bool.parse(string) : null;
  }

  @override
  void setLanguageCode(String code) {
    prefs.setString('languageCode', code);
    _notify();
  }

  @override
  String? get languageCode {
    return prefs.getString('languageCode');
  }

  void _notify() {
    _subject.add(null);
  }

  @override
  ValueStream<void> get stream => _subject.stream;
}
