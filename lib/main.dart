import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/hill/hill.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_io_parameters_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repository.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/country_flags.dart/country_flags_repo.dart';
import 'package:sj_manager/repositories/country_flags.dart/local_storage_country_flags_repo.dart';
import 'package:sj_manager/repositories/database_editing/default_items_repository.dart';
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

  MaleJumper maleJumperFromJson(Json json, BuildContext context) {
    return MaleJumper.fromJson(
      json,
      countryLoader: JsonCountryLoaderByCode(repo: context.read()),
    );
  }

  FemaleJumper femaleJumperFromJson(Json json, BuildContext context) {
    return FemaleJumper.fromJson(
      json,
      countryLoader: JsonCountryLoaderByCode(repo: context.read()),
    );
  }

  Hill hillFromJson(Json json, BuildContext context) {
    return Hill.fromJson(
      json,
      countryLoader: JsonCountryLoaderByCode(repo: context.read()),
    );
  }

  runApp(
    BlocProvider(
      create: (context) => LocaleCubit(),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CountriesRepo>(
            create: (context) => CountriesRepo(),
          ),
          RepositoryProvider<CountryFlagsRepo>(
            create: (context) {
              final storageDirectory =
                  userDataDirectory(pathsCache, 'countries/country_flags');
              return LocalStorageCountryFlagsRepo(
                imagesDirectory: storageDirectory,
                imagesExtension: 'png',
              );
            },
          ),
          RepositoryProvider(
            create: (context) => DbItemsRepo<MaleJumper>(),
          ),
          RepositoryProvider(
            create: (context) => DbItemsRepo<FemaleJumper>(),
          ),
          RepositoryProvider(
            create: (context) => DbItemsRepo<Hill>(),
          ),
          RepositoryProvider(create: (context) {
            final noneCountry = context.read<CountriesRepo>().none;
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
                  imagesDirectory:
                      userDataDirectory(pathsCache, 'database/jumper_images'),
                  toFileName: (jumper) {
                    return '${jumper.country.code.toLowerCase()}_${jumper.name.toLowerCase()}_${jumper.surname.toLowerCase()}'
                        .replaceAll(' ', '_');
                  },
                  extension: 'png');
            }),
            Provider(create: (context) {
              return HillImageGeneratingSetup(
                  imagesDirectory: userDataDirectory(pathsCache, 'database/hill_images'),
                  toFileName: (hill) {
                    return '${hill.locality.toLowerCase()}_${hill.hs.truncate().toString()}'
                        .replaceAll(' ', '_');
                  });
            }),
            Provider(create: (context) {
              return DbIoParametersRepo<MaleJumper>(
                storageFile: userDataFile(pathsCache, 'database/jumpers_male.json'),
                fromJson: (json) => maleJumperFromJson(json, context),
                toJson: (jumper) => jumper.toJson(
                  countrySaver: const JsonCountryCodeSaver(),
                ),
              );
            }),
            Provider(create: (context) {
              return DbIoParametersRepo<FemaleJumper>(
                storageFile: userDataFile(pathsCache, 'database/jumpers_female.json'),
                fromJson: (json) => femaleJumperFromJson(json, context),
                toJson: (jumper) => jumper.toJson(
                  countrySaver: const JsonCountryCodeSaver(),
                ),
              );
            }),
            Provider(create: (context) {
              return DbIoParametersRepo<Hill>(
                storageFile: userDataFile(pathsCache, 'database/hills.json'),
                fromJson: (json) => hillFromJson(json, context),
                toJson: (hill) => hill.toJson(
                  countrySaver: const JsonCountryCodeSaver(),
                ),
              );
            }),
            Provider(create: (context) {
              return DbIoParametersRepo<Country>(
                storageFile: userDataFile(pathsCache, 'countries/countries.json'),
                fromJson: (json) {
                  return Country.fromMultilingualJson(
                      json, context.read<LocaleCubit>().languageCode);
                },
                toJson: (hill) => {},
              );
            }),
            Provider(
              create: (context) => AppConfigurator(
                shouldSetUpRouting: true,
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
