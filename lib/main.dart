import 'dart:async';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sj_manager/features/app_settings/data/data_sources/shared_prefs_app_settings_data_source.dart';
import 'package:sj_manager/features/app_settings/data/repository/local_app_settings_repository.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/get_app_color_scheme_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/get_app_language_code_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/set_app_color_scheme_use_case.dart';
import 'package:sj_manager/features/app_settings/domain/use_cases/set_app_language_code_use_case.dart';
import 'package:sj_manager/features/app_settings/presentation/bloc/app_settings_cubit.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/general_utils/db_items_file_system_paths.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team_db_record.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';
import 'package:sj_manager/to_embrace/ui/app.dart';
import 'package:sj_manager/to_embrace/ui/app_initializer.dart';
import 'package:sj_manager/general_ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/main_menu/ui/main_screen.dart';
import 'package:sj_manager/core/general_utils/file_system.dart';
import 'package:sj_manager/core/general_utils/id_generator.dart';
import 'package:path/path.dart' as path;
import 'package:sj_manager/core/general_utils/logging/errors_logger.dart';
import 'package:sj_manager/core/general_utils/platform.dart';
import 'package:window_manager/window_manager.dart';

final mainNavigatorKey = GlobalKey<NavigatorState>();
final router = FluroRouter();
bool routerIsInitialized = false;

void main() async {
  final pathsCache = PlarformSpecificPathsCache();
  await pathsCache.setup();
  final logger = LoggerService();
  await logger.init(pathsCache);

  final settingsRepository = LocalAppSettingsRepository(
    settingsDataSource: SharedPrefsAppSettingsDataSourceImpl(
      prefs: await SharedPreferences.getInstance(),
    ),
  );

  final app = MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AppSettingsCubit(
          setColorSchemeUseCase:
              SetAppColorSchemeUseCase(settingsRepository: settingsRepository),
          setLanguageCodeUseCase:
              SetAppLanguageCodeUseCase(settingsRepository: settingsRepository),
          getColorScheme:
              GetAppColorSchemeUseCase(settingsRepository: settingsRepository),
          getLanguageCode:
              GetAppLanguageCodeUseCase(settingsRepository: settingsRepository),
        ),
      ),
    ],
    child: MultiProvider(
      providers: [
        Provider<DbItemsFilePathsRegistry>(
          create: (context) => DbItemsFilePathsRegistry(initial: {
            MaleJumperDbRecord: 'jumpers_male.json',
            FemaleJumperDbRecord: 'jumpers_female.json',
            SimulationMaleJumper: 'jumpers_male.json',
            SimulationFemaleJumper: 'jumpers_female.json',
            Hill: 'hills.json',
            Country: path.join('countries', 'countries.json'),
            CountryTeamDbRecord: path.join('teams', 'country_teams.json'),
            Subteam: path.join('teams', 'subteams.json'),
            SimulationSeason: 'seasons.json',
          }),
        ),
        Provider(
          create: (context) => DbItemsDirectoryPathsRegistry(
            initial: {
              CountryFlag: path.join('countries', 'country_flags'),
            },
          ),
        ),
        Provider<IdGenerator>(create: (context) {
          return const NanoIdGenerator(size: 15);
        }),
        Provider.value(
          value: pathsCache,
        ),
      ],
      child: App(
        home: Builder(builder: (context) {
          return const AppInitializer(
            shouldSetUpRouting: true,
            shouldSetUpUserData: true,
            shouldLoadGameVariants: true,
            shouldLoadSimulations: true,
            child: MainScreen(),
          );
        }),
      ),
    ),
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    logger.logError(details.exception, details.stack);
  };

  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (platformIsDesktop) {
        await windowManager.ensureInitialized();
        await WindowManager.instance.setMinimumSize(const Size(1350, 850));
      }
      runApp(app);
    },
    (error, stackTrace) {
      logger.logError(error, stackTrace);
      throw error;
    },
  );
}
