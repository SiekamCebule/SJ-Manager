import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/my_bloc_observer.dart';
import 'package:sj_manager/models/jumper.dart';
import 'package:sj_manager/repositories/database_items/predefined_types.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/theme/app_theme_brightness_cubit.dart';
import 'package:sj_manager/ui/theme/color_scheme_cubit.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';
import 'package:sj_manager/utils/file_system.dart';

void main() async {
  final pathsCache = PlarformSpecificPathsCache();
  await pathsCache.setup();

  Bloc.observer = MyBlocObserver();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) {
            final storageFile = databaseFile(pathsCache, 'jumpers_male.json');
            return MaleJumpersDatabaseRepo(
              storageFile: storageFile,
              fromJson: Jumper.fromJson,
            );
          },
        ),
        RepositoryProvider(
          create: (context) {
            final storageFile = databaseFile(pathsCache, 'jumpers_female.json');
            return FemaleJumpersDatabaseRepo(
              storageFile: storageFile,
              fromJson: Jumper.fromJson,
            );
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppThemeBrightnessCubit(),
          ),
          BlocProvider(
            create: (context) => AppColorSchemeCubit(),
          ),
          BlocProvider(create: (context) {
            return ThemeCubit(
              appSchemeSubscription:
                  BlocProvider.of<AppColorSchemeCubit>(context).stream.listen(null),
              appThemeBrightnessSubscription:
                  BlocProvider.of<AppThemeBrightnessCubit>(context).stream.listen(null),
            );
          }),
        ],
        child: const App(),
      ),
    ),
  );
}
