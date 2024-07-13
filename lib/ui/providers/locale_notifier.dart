import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  // TODO: Embrace it
  // _locale = Locale(Platform.localeName.substring(0, 2))
  LocaleCubit({Locale? initial}) : super(initial ?? const Locale('pl'));

  void update(Locale locale) {
    emit(locale);
  }

  String get languageCode => state.languageCode;
}
