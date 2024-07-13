import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';

class AppThemeBrightnessRepo {
  final _subject = BehaviorSubject.seeded(UiGlobalConstants.defaultAppThemeBrightness);

  void update(Brightness brightness) {
    _subject.add(brightness);
  }

  void toggle() {
    _subject.add(state == Brightness.light ? Brightness.dark : Brightness.light);
  }

  void dipose() => _subject.close();

  Brightness get state => values.value;
  ValueStream<Brightness> get values => _subject.stream;
}
