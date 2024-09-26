import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_image_asset.dart';
import 'package:sj_manager/models/simulation_db/user_simulation.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/repositories/settings/local_user_settings_repo.dart';
import 'package:sj_manager/repositories/settings/user_settings_repo.dart';
import 'package:sj_manager/setup/game_variants_loader.dart';
import 'package:sj_manager/setup/simulations_loader.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/app_initializer.dart';
import 'package:sj_manager/ui/providers/locale_cubit.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/id_generator.dart';
import 'package:path/path.dart' as path;

final router = FluroRouter();
bool routerIsInitialized = false;

void main() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  final pathsCache = PlarformSpecificPathsCache();
  await pathsCache.setup();

  runApp(
    MultiRepositoryProvider(
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
              Provider(create: (context) {
                return DbItemImageGeneratingSetup<Jumper>(
                  imagesDirectory:
                      databaseDirectory(pathsCache, path.join('jumper_images')),
                  toFileName: (jumper) {
                    return '${jumper.country.code.toLowerCase()}_${jumper.name.toLowerCase()}_${jumper.surname.toLowerCase()}'
                        .replaceAll(' ', '_');
                  },
                );
              }),
              Provider(create: (context) {
                return DbItemImageGeneratingSetup<Hill>(
                    imagesDirectory:
                        databaseDirectory(pathsCache, path.join('hill_images')),
                    toFileName: (hill) {
                      return '${hill.locality.toLowerCase()}_${hill.hs.truncate().toString()}'
                          .replaceAll(' ', '_');
                    });
              }),
              Provider(create: (context) {
                return DbItemImageGeneratingSetup<EventSeriesLogoImageWrapper>(
                    imagesDirectory:
                        databaseDirectory(pathsCache, path.join('assets', 'logos')),
                    toFileName: (logoImage) => logoImage.eventSeriesSetup.id);
              }),
              Provider(create: (context) {
                return DbItemImageGeneratingSetup<EventSeriesTrophyImageWrapper>(
                    imagesDirectory:
                        databaseDirectory(pathsCache, path.join('assets', 'trophies')),
                    toFileName: (logoImage) => logoImage.eventSeriesSetup.id);
              }),
              ...constructSimulationDbIoProvidersList(),
              Provider(
                create: (context) => DbItemsFilePathsRegistry(initial: {
                  MaleJumper: 'jumpers_male.json',
                  FemaleJumper: 'jumpers_female.json',
                  Hill: 'hills.json',
                  Country: path.join('countries', 'countries.json'),
                  Team: path.join('teams', 'teams.json'),
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
                create: (context) => EditableItemsRepo<UserSimulation>(),
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
    ),
  );
}

List constructSimulationDbIoProvidersList() {
  CountriesRepo countriesRepo(BuildContext context) =>
      context.read<ItemsReposRegistry>().get<Country>() as CountriesRepo;

  MaleJumper maleJumperFromJson(Json json, BuildContext context) {
    return MaleJumper.fromJson(
      json,
      countryLoader: JsonCountryLoaderByCode(repo: countriesRepo(context)),
    );
  }

  FemaleJumper femaleJumperFromJson(Json json, BuildContext context) {
    return FemaleJumper.fromJson(
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
      return DbItemsJsonConfiguration<MaleJumper>(
        fromJson: (json) => maleJumperFromJson(json, context),
        toJson: (jumper) => jumper.toJson(
          countrySaver: const JsonCountryCodeSaver(),
        ),
      );
    }),
    Provider(create: (context) {
      return DbItemsJsonConfiguration<FemaleJumper>(
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
