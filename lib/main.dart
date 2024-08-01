import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/json/manual_json/json_team.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/db_file_system_entity_names.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/local_db_repo.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/repositories/countries/country_flags/local_storage_country_flags_repo.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/setup/set_up_app.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/providers/locale_notifier.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/hill_image/hill_image_generating_setup.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/jumper_image/jumper_image_generating_setup.dart';
import 'package:sj_manager/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/ui/theme/app_theme_brightness_repo.dart';
import 'package:sj_manager/ui/theme/app_color_scheme_repo.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';
import 'package:sj_manager/utils/file_system.dart';

final router = FluroRouter();
bool routerIsInitialized = false;

void main() async {
  final pathsCache = PlarformSpecificPathsCache();
  await pathsCache.setup();

  CountriesRepo countriesRepo(BuildContext context) =>
      context.read<LocalDbRepo>().countries;

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

  runApp(
    BlocProvider(
      create: (context) => LocaleCubit(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CountryFlagsRepo>(
            create: (context) {
              final storageDirectory =
                  userDataDirectory(pathsCache, 'database/countries/country_flags');
              return LocalStorageCountryFlagsRepo(
                imagesDirectory: storageDirectory,
                imagesExtension: 'png',
              );
            },
          ),
          RepositoryProvider(
            create: (context) => LocalDbRepo(
              maleJumpers: EditableItemsRepo<MaleJumper>(),
              femaleJumpers: EditableItemsRepo<FemaleJumper>(),
              hills: EditableItemsRepo<Hill>(),
              countries: CountriesRepo(),
              teams: TeamsRepo(),
            ),
          ),
          RepositoryProvider(create: (context) {
            final noneCountry = context.read<LocalDbRepo>().countries.none;
            return DefaultItemsRepo(
              defaultFemaleJumper: FemaleJumper.empty(country: noneCountry),
              defaultMaleJumper: MaleJumper.empty(country: noneCountry),
              defaultHill: Hill.empty(country: noneCountry),
            );
          }),
          RepositoryProvider(create: (context) {
            return DbEditingDefaultsRepo.appDefault();
          }),
          RepositoryProvider(
            create: (context) => AppThemeBrightnessRepo(),
          ),
          RepositoryProvider(
            create: (context) => AppColorSchemeRepo(),
          ),
        ],
        child: MultiProvider(
          providers: [
            Provider(create: (context) {
              return JumperImageGeneratingSetup(
                imagesDirectory: userDataDirectory(pathsCache, 'database/jumper_images'),
                toFileName: (jumper) {
                  return '${jumper.country.code.toLowerCase()}_${jumper.name.toLowerCase()}_${jumper.surname.toLowerCase()}'
                      .replaceAll(' ', '_');
                },
              );
            }),
            Provider(create: (context) {
              return HillImageGeneratingSetup(
                  imagesDirectory: userDataDirectory(pathsCache, 'database/hill_images'),
                  toFileName: (hill) {
                    return '${hill.locality.toLowerCase()}_${hill.hs.truncate().toString()}'
                        .replaceAll(' ', '_');
                  });
            }),
            Provider(
              create: (context) => const DbFileSystemEntityNames(
                maleJumpers: 'jumpers_male.json',
                femaleJumpers: 'jumpers_female.json',
                hills: 'hills.json',
                countries: 'countries/countries.json',
                countryFlags: 'countries/country_flags',
                teams: 'teams/teams.json',
              ),
            ),
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
            Provider(create: (context) {
              return DbItemsJsonConfiguration<Country>(
                fromJson: (json) {
                  return Country.fromMultilingualJson(
                      json, context.read<LocaleCubit>().languageCode);
                },
                toJson: (hill) => {},
              );
            }),
            Provider(create: (context) {
              return DbItemsJsonConfiguration<Team>(
                fromJson: (json) => JsonTeamParser(
                        countryLoader:
                            JsonCountryLoaderByCode(repo: countriesRepo(context)))
                    .parseTeam(json),
                toJson: (team) =>
                    JsonTeamSerializer(countrySaver: const JsonCountryCodeSaver())
                        .serializeTeam(team),
              );
            }),
            Provider.value(
              value: pathsCache,
            ),
            Provider(
              create: (context) => AppConfigurator(
                shouldSetUpRouting: true,
                shouldSetUpUserData: true,
                shouldLoadDatabase: true,
              ),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) {
                return ThemeCubit(
                  colorSchemeRepo: context.read(),
                  brightnessRepo: context.read(),
                );
              }),
            ],
            child: const App(
              home: MainScreen(),
            ),
          ),
        ),
      ),
    ),
  );
}
