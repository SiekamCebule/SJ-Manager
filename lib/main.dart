import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sj_manager/bloc/simulation_db_loading/classification_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/competition_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/competition_round_rules_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/competition_rules_provider_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/entities_limit_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/event_series_calendar_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/event_series_calendar_preset_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/event_series_setup_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/standings_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/team_competition_group_rules_loader.dart';
import 'package:sj_manager/bloc/simulation_db_saving/classification_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/competition_round_rules_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/competition_rules_provider_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/competition_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/entities_limit_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/event_series_calendar_preset_serialier.dart';
import 'package:sj_manager/bloc/simulation_db_saving/event_series_calendar_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/event_series_setup_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/score_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/standings_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/team_competition_group_rules_serializer.dart';
import 'package:sj_manager/json/manual_json/json_team.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_provider.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_image_asset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
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
import 'package:sj_manager/repositories/generic/ids_repo.dart';
import 'package:sj_manager/setup/set_up_app.dart';
import 'package:sj_manager/ui/app.dart';
import 'package:sj_manager/ui/providers/locale_notifier.dart';
import 'package:sj_manager/ui/reusable_widgets/database_item_images/db_item_image_generating_setup.dart';
import 'package:sj_manager/ui/screens/main_screen/main_screen.dart';
import 'package:sj_manager/ui/theme/app_theme_brightness_repo.dart';
import 'package:sj_manager/ui/theme/app_color_scheme_repo.dart';
import 'package:sj_manager/ui/theme/theme_cubit.dart';
import 'package:sj_manager/utils/file_system.dart';
import 'package:sj_manager/utils/id_generator.dart';

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
              eventSeriesSetups: EditableItemsRepo<EventSeriesSetup>(),
              eventSeriesCalendars: EditableItemsRepo<EventSeriesCalendarPreset>(),
              competitionRulesPresets: EditableItemsRepo<CompetitionRulesPreset>(),
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
              defaultEventSeriesSetup: const EventSeriesSetup.empty(),
              defaultEventSeriesCalendar: const EventSeriesCalendarPreset.empty(),
              defaultCompetitionRules: const CompetitionRules.empty(),
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
              return DbItemImageGeneratingSetup<Jumper>(
                imagesDirectory: userDataDirectory(pathsCache, 'database/jumper_images'),
                toFileName: (jumper) {
                  return '${jumper.country.code.toLowerCase()}_${jumper.name.toLowerCase()}_${jumper.surname.toLowerCase()}'
                      .replaceAll(' ', '_');
                },
              );
            }),
            Provider(create: (context) {
              return DbItemImageGeneratingSetup<Hill>(
                  imagesDirectory: userDataDirectory(pathsCache, 'database/hill_images'),
                  toFileName: (hill) {
                    return '${hill.locality.toLowerCase()}_${hill.hs.truncate().toString()}'
                        .replaceAll(' ', '_');
                  });
            }),
            Provider(create: (context) {
              return DbItemImageGeneratingSetup<EventSeriesLogoImageWrapper>(
                  imagesDirectory: userDataDirectory(pathsCache, 'database/assets/logos'),
                  toFileName: (logoImage) => logoImage.eventSeriesSetup.id);
            }),
            Provider(create: (context) {
              return DbItemImageGeneratingSetup<EventSeriesTrophyImageWrapper>(
                  imagesDirectory:
                      userDataDirectory(pathsCache, 'database/assets/trophies'),
                  toFileName: (logoImage) => logoImage.eventSeriesSetup.id);
            }),
            Provider(
              create: (context) => const DbFileSystemEntityNames(
                maleJumpers: 'jumpers_male.json',
                femaleJumpers: 'jumpers_female.json',
                hills: 'hills.json',
                eventSeriesSetups: 'event_series_setups.json',
                eventSeriesCalendars: 'event_series_setups.json',
                competitionRulesPresets: 'event_series_setups.json',
                countries: 'countries/countries.json',
                countryFlags: 'countries/country_flags',
                teams: 'teams/teams.json',
              ),
            ),
            Provider(create: (context) {
              return IdsRepo();
            }),
            Provider(create: (context) {
              return const NanoIdGenerator(size: 10);
            }),
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
            Provider(create: (context) {
              return DbItemsJsonConfiguration<EventSeriesSetup>(
                fromJson: (json) =>
                    EventSeriesSetupLoader(idsRepo: context.read()).load(json),
                toJson: (series) =>
                    EventSeriesSetupSerializer(idsRepo: context.read()).serialize(series),
              );
            }),
            Provider(create: (context) {
              return DbItemsJsonConfiguration<CompetitionRulesProvider>(
                fromJson: (json) => CompetitionRulesProviderLoader(
                  idsRepo: context.read(),
                  roundRulesLoader: CompetitionRoundRulesLoader(
                    idsRepo: context.read(),
                    entitiesLimitLoader: EntitiesLimitLoader(idsRepo: context.read()),
                    positionsCreatorLoader: StandingsPositionsCreatorLoader(),
                    teamCompetitionGroupRulesLoader:
                        TeamCompetitionGroupRulesLoader(idsRepo: context.read()),
                  ),
                ).load(json),
                toJson: (provider) => CompetitionRulesProviderSerializer(
                  idsRepo: context.read(),
                  roundRulesSerializer: CompetitionRoundRulesSerializer(
                    idsRepo: context.read(),
                    teamCompetitionGroupRulesSerializer:
                        TeamCompetitionGroupRulesSerializer(idsRepo: context.read()),
                    entitiesLimitSerializer:
                        EntitiesLimitSerializer(idsRepo: context.read()),
                    positionsCreatorSerializer: StandingsPositionsCreatorSerializer(),
                  ),
                ).serialize(provider),
              );
            }),
            Provider(create: (context) {
              return StandingsLoader(
                idsRepo: context.read(),
                idGenerator: context.read(),
                scoreLoader: ScoreLoader(
                  idsRepo: context.read(),
                ),
                positionsCreatorLoader: StandingsPositionsCreatorLoader(),
              );
            }),
            Provider(create: (context) {
              return StandingsSerializer(
                idsRepo: context.read(),
                scoreSerializer: ScoreSerializer(
                  idsRepo: context.read(),
                ),
                positionsCreatorSerializer: StandingsPositionsCreatorSerializer(),
              );
            }),
            Provider(create: (context) {
              return DbItemsJsonConfiguration<EventSeriesCalendarPreset>(
                fromJson: (json) => EventSeriesCalendarPresetLoader(
                  idsRepo: context.read(),
                  calendarLoader: EventSeriesCalendarLoader(
                    idsRepo: context.read(),
                    idGenerator: context.read(),
                    competitionLoader: CompetitionLoader(
                      idsRepo: context.read(),
                      rulesLoader: context.read(),
                      standingsLoader: context.read(),
                    ),
                    classificationLoader: ClassificationLoader(
                      idsRepo: context.read(),
                      standingsLoader: context.read(),
                    ),
                  ),
                ).load(json),
                toJson: (preset) => EventSeriesCalendarPresetSerializer(
                  idsRepo: context.read(),
                  calendarSerializer: EventSeriesCalendarSerializer(
                    idsRepo: context.read(),
                    competitionSerializer: CompetitionSerializer(
                        idsRepo: context.read(),
                        competitionRulesSerializer: context.read(),
                        standingsSerializer: context.read()),
                    classificationSerializer: ClassificationSerializer(
                      idsRepo: context.read(),
                      standingsSerializer: context.read(),
                    ),
                  ),
                ).serialize(preset),
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
