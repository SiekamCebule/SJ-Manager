import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/theme/app_theme_brightness_cubit.dart';
import 'package:sj_manager/ui/theme/color_scheme_cubit.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppThemeBrightnessCubit(),
        ),
        BlocProvider(
          create: (context) => AppColorSchemeCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (context) {
              return ThemeCubit(
                appSchemeSubscription:
                    BlocProvider.of<AppColorSchemeCubit>(context).stream.listen(null),
                appThemeBrightnessSubscription:
                    BlocProvider.of<AppThemeBrightnessCubit>(context).stream.listen(null),
              );
            },
            child: const App(),
          );
        },
      ),
    ),
  );
}
