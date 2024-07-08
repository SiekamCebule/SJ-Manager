import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier, WidgetsBindingObserver {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
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
