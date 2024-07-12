import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';

class AppThemeBrightnessCubit extends Cubit<Brightness> {
  AppThemeBrightnessCubit() : super(UiGlobalConstants.defaultAppThemeBrightness);

  void update(Brightness brightness) {
    emit(brightness);
  }

  void toggle() {
    emit(state == Brightness.light ? Brightness.dark : Brightness.light);
  }
}
