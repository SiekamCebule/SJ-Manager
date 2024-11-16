import 'dart:async';
import 'dart:ui';

import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sj_manager/data/models/game_variants/game_variant.dart';
import 'package:sj_manager/data/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/data/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/data/models/simulation/user_simulation/user_simulation_model.dart';
import 'package:sj_manager/data/models/database/country/country.dart';
import 'package:sj_manager/data/models/database/db_items_file_system_paths.dart';
import 'package:sj_manager/data/models/database/hill/hill.dart';
import 'package:sj_manager/data/models/database/items_repos_registry.dart';
import 'package:sj_manager/data/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/data/models/database/team/subteam.dart';
import 'package:sj_manager/domain/repository_interfaces/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/db_items_json_configuration.dart';
import 'package:sj_manager/utilities/json/countries.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/countries_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/editable_items_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/settings/local_user_settings_repo.dart';
import 'package:sj_manager/domain/repository_interfaces/settings/user_settings_repo.dart';
import 'package:sj_manager/setup/game_variants_loader.dart';
import 'package:sj_manager/setup/simulations_loader.dart';
import 'package:sj_manager/presentation/ui/app.dart';
import 'package:sj_manager/presentation/ui/app_initializer.dart';
import 'package:sj_manager/presentation/ui/providers/locale_cubit.dart';
import 'package:sj_manager/presentation/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/presentation/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/presentation/ui/theme/theme_cubit.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
import 'package:sj_manager/utilities/utils/id_generator.dart';
import 'package:path/path.dart' as path;
import 'package:sj_manager/utilities/utils/logging/errors_logger.dart';
import 'package:sj_manager/utilities/utils/platform.dart';
import 'package:window_manager/window_manager.dart';

final mainNavigatorKey = GlobalKey<NavigatorState>();
final router = FluroRouter();
bool routerIsInitialized = false;

void main() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final pathsCache = PlarformSpecificPathsCache();
  await pathsCache.setup();
  final logger = LoggerService();
  await logger.init(pathsCache);

  final app = MultiRepositoryProvider(
    providers: [
      RepositoryProvider<UserSettingsRepo>(
        create: (context) => LocalUserSettingsRepo(
          prefs: sharedPrefs,
        ),
      ),
    ],
    child: BlocProvider(
      create: (context) => LocaleCubit(
        settingsRepo: context.read(),
      ),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) {
            return DbEditingDefaultsRepo.appDefault();
          }),
        ],
        child: MultiProvider(
          providers: [
            ...constructSimulationDbIoProvidersList(),
            Provider(
              create: (context) => DbItemsFilePathsRegistry(initial: {
                MaleJumperDbRecord: 'jumpers_male.json',
                FemaleJumperDbRecord: 'jumpers_female.json',
                SimulationMaleJumper: 'jumpers_male.json',
                SimulationFemaleJumper: 'jumpers_female.json',
                Hill: 'hills.json',
                Country: path.join('countries', 'countries.json'),
                CountryTeam: path.join('teams', 'country_teams.json'),
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
            Provider(
              create: (context) => ItemsRepo<GameVariant>(),
            ),
            Provider(
              create: (context) => EditableItemsRepo<UserSimulationModel>(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) {
                return ThemeCubit(
                  settingsRepo: context.read(),
                );
              }),
            ],
            child: App(
              home: Builder(builder: (context) {
                return AppInitializer(
                  shouldSetUpRouting: true,
                  shouldSetUpUserData: true,
                  shouldLoadDatabase: true,
                  createLoaders: (context) => [
                    GameVariantsLoader(context: context),
                    SimulationsLoader(
                      context: context,
                      idGenerator: context.read(),
                      pathsRegistry: context.read(),
                      pathsCache: context.read(),
                      simulationsRepo: context.read(),
                    ),
                  ],
                  child: const MainScreen(),
                );
              }),
            ),
          ),
        ),
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
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        silent: false,
      ));
    },
  );
}

List constructSimulationDbIoProvidersList() {
  CountriesRepo countriesRepo(BuildContext context) =>
      context.read<ItemsReposRegistry>().get<Country>() as CountriesRepo;

  MaleJumperDbRecord maleJumperFromJson(Json json, BuildContext context) {
    return MaleJumperDbRecord.fromJson(
      json,
      countryLoader: JsonCountryLoaderByCode(repo: countriesRepo(context)),
    );
  }

  FemaleJumperDbRecord femaleJumperFromJson(Json json, BuildContext context) {
    return FemaleJumperDbRecord.fromJson(
      json,
      countryLoader: JsonCountryLoaderByCode(repo: countriesRepo(context)),
    );
  }

  Hill hillFromJson(Json json, BuildContext context) {
    return Hill.fromJson(
      json,
      countryLoader: JsonCountryLoaderByCode(repo: countriesRepo(context)),
    );
  }

  return [
    Provider(create: (context) {
      return DbItemsJsonConfiguration<MaleJumperDbRecord>(
        fromJson: (json) => maleJumperFromJson(json, context),
        toJson: (jumper) => jumper.toJson(
          countrySaver: const JsonCountryCodeSaver(),
        ),
      );
    }),
    Provider(create: (context) {
      return DbItemsJsonConfiguration<FemaleJumperDbRecord>(
        fromJson: (json) => femaleJumperFromJson(json, context),
        toJson: (jumper) => jumper.toJson(
          countrySaver: const JsonCountryCodeSaver(),
        ),
      );
    }),
    Provider(create: (context) {
      return DbItemsJsonConfiguration<Hill>(
        fromJson: (json) => hillFromJson(json, context),
        toJson: (hill) => hill.toJson(
          countrySaver: const JsonCountryCodeSaver(),
        ),
      );
    }),
    Provider<DbItemsJsonConfiguration<Country>>(create: (context) {
      return DbItemsJsonConfiguration<Country>(
        fromJson: (json) {
          return Country.fromJson(json);
        },
        toJson: (country) {
          return country.toJson();
        },
      );
    }),
  ];
}
