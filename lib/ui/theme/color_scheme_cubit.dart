import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/ui/responsiveness/ui_main_menu_constants.dart';
import 'package:sj_manager/ui/theme/app_schemes.dart';

class AppColorSchemeCubit extends Cubit<AppColorScheme> {
  AppColorSchemeCubit() : super(UiGlobalConstants.defaultAppColorScheme);

  void update(AppColorScheme scheme) {
    emit(scheme);
  }
}
