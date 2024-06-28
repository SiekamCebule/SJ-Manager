import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/ui/responsiveness/ui_constants.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

class AppColorSchemeCubit extends Cubit<AppColorScheme> {
  AppColorSchemeCubit() : super(UiConstants.defaultAppColorScheme);

  void update(AppColorScheme scheme) {
    emit(scheme);
  }
}
