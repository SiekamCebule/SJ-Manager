import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier, WidgetsBindingObserver {
  Locale _locale;

  Locale? get locale => _locale;

  // TODO: Embrace it
  // _locale = Locale(Platform.localeName.substring(0, 2))
  LocaleProvider({Locale? initial}) : _locale = initial ?? const Locale('pl') {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null && locales.isNotEmpty) {
      _locale = locales.first;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
