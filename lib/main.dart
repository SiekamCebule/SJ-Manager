import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sj_manager/json/simulation_db_loading/classification_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/classification_score_creator_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/competition_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/competition_round_rules_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/competition_rules_preset_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/competition_rules_provider_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/competition_score_creator_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/default_classification_rules_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/default_competition_rules_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/entities_limit_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/event_series_calendar_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/event_series_calendar_preset_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/event_series_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/event_series_setup_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/high_level_calendar_parser.dart';
import 'package:sj_manager/json/simulation_db_loading/judges_creator_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/jump_score_creator_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/ko_groups_creator_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/ko_round_advancement_determinator_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/ko_round_rules_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/main_competition_record_parser.dart';
import 'package:sj_manager/json/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/simulation_season_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/standings_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/team_competition_group_rules_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/team_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/wind_averager_parser.dart';
import 'package:sj_manager/json/simulation_db_saving/classification_score_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/classification_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/competition_rules_preset_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/competition_rules_provider_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/competition_score_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/competition_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/default_classification_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/default_competition_round_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/default_competition_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/entities_limit_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/event_series_calendar_preset_serialier.dart';
import 'package:sj_manager/json/simulation_db_saving/event_series_calendar_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/event_series_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/event_series_setup_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/high_level_calendar_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/judges_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/jump_score_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/ko_groups_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/ko_round_advancement_determinator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/ko_round_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/main_competition_record_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/score_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/simulation_season_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/standings_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/team_competition_group_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/team_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/wind_averager_serializer.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_image_asset.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/items_repos_registry.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/database_editing/db_editing_defaults_repo.dart';
import 'package:sj_manager/repositories/generic/db_items_json_configuration.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';
import 'package:sj_manager/repositories/settings/local_user_settings_repo.dart';
import 'package:sj_manager/repositories/settings/user_settings_repo.dart';
import 'package:sj_manager/setup/game_variants_loader.dart';
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
            RepositoryProvider(
              create: (context) => ItemsReposRegistry(initial: {
                EditableItemsRepo<MaleJumper>(),
                EditableItemsRepo<FemaleJumper>(),
                EditableItemsRepo<Hill>(),
                EditableItemsRepo<EventSeriesSetup>(),
                EditableItemsRepo<EventSeriesCalendarPreset>(),
                EditableItemsRepo<DefaultCompetitionRulesPreset>(),
                TeamsRepo(),
                CountriesRepo(),
              }),
            ),
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
              Provider<ValueRepo<ItemsIdsRepo>>(create: (context) {
                return ValueRepo(initial: ItemsIdsRepo<String>());
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
    ProxyProvider<ValueRepo<ItemsIdsRepo>, DbItemsJsonConfiguration<Team>>(
      update: (context, itemIdsRepo, previous) {
        return DbItemsJsonConfiguration<Team>(
          fromJson: (json) => TeamLoader(
            idsRepo: itemIdsRepo.last, // Get the latest idsRepo from ValueRepo
            countryLoader: JsonCountryLoaderByCode(repo: countriesRepo(context)),
          ).parse(json),
          toJson: (team) => TeamSerializer(
            idsRepo: itemIdsRepo.last, // Use the updated idsRepo
          ).serialize(team),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, DbItemsJsonConfiguration<EventSeriesSetup>>(
      update: (context, itemIdsRepo, previous) {
        return DbItemsJsonConfiguration<EventSeriesSetup>(
          fromJson: (json) =>
              EventSeriesSetupParser(idsRepo: itemIdsRepo.last).parse(json),
          toJson: (series) =>
              EventSeriesSetupSerializer(idsRepo: itemIdsRepo.last).serialize(series),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, SimulationDbPartParser<Standings>>(
      update: (context, itemIdsRepo, previous) {
        return StandingsParser(
          idsRepo: itemIdsRepo.last,
          idGenerator: context.read(),
          scoreParser: ScoreParser(idsRepo: itemIdsRepo.last),
          positionsCreatorParser: StandingsPositionsCreatorParser(),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, SimulationDbPartSerializer<Standings>>(
      update: (context, itemIdsRepo, previous) {
        return StandingsSerializer(
          idsRepo: itemIdsRepo.last,
          scoreSerializer: ScoreSerializer(idsRepo: itemIdsRepo.last),
          positionsCreatorSerializer: StandingsPositionsCreatorSerializer(),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, SimulationDbPartParser<Classification>>(
      update: (context, itemIdsRepo, previous) {
        return ClassificationParser(
          idsRepo: itemIdsRepo.last,
          standingsParser: context.read(),
          defaultClassificationRulesParser: DefaultClassificationRulesParser(
            idsRepo: itemIdsRepo.last,
            classificationScoreCreatorParser:
                ClassificationScoreCreatorParser(idsRepo: itemIdsRepo.last),
          ),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, SimulationDbPartSerializer<Classification>>(
      update: (context, itemIdsRepo, previous) {
        return ClassificationSerializer(
          idsRepo: itemIdsRepo.last,
          standingsSerializer: context.read(),
          defaultClassificationRulesSerializer: DefaultClassificationRulesSerializer(
            idsRepo: itemIdsRepo.last,
            classificationScoreCreatorSerializer:
                ClassificationScoreCreatorSerializer(idsRepo: itemIdsRepo.last),
          ),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        SimulationDbPartParser<DefaultCompetitionRoundRules>>(
      update: (context, itemIdsRepo, previous) {
        return CompetitionRoundRulesParser(
          idsRepo: itemIdsRepo.last,
          entitiesLimitParser: EntitiesLimitParser(idsRepo: itemIdsRepo.last),
          positionsCreatorParser: StandingsPositionsCreatorParser(),
          teamCompetitionGroupRulesParser:
              TeamCompetitionGroupRulesParser(idsRepo: itemIdsRepo.last),
          koRoundRulesParser: KoRoundRulesParser(
            idsRepo: itemIdsRepo.last,
            advancementDeterminatorParser: KoRoundAdvancementDeterminatorLoader(
              idsRepo: itemIdsRepo.last,
              entitiesLimitParser: EntitiesLimitParser(idsRepo: itemIdsRepo.last),
            ),
            koGroupsCreatorParser: KoGroupsCreatorLoader(idsRepo: itemIdsRepo.last),
          ),
          windAveragerParser: WindAveragerParser(idsRepo: itemIdsRepo.last),
          judgesCreatorParser: JudgesCreatorLoader(idsRepo: itemIdsRepo.last),
          competitionScoreCreatorParser:
              CompetitionScoreCreatorLoader(idsRepo: itemIdsRepo.last),
          jumpScoreCreatorParser: JumpScoreCreatorLoader(idsRepo: itemIdsRepo.last),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        SimulationDbPartSerializer<DefaultCompetitionRoundRules>>(
      update: (context, itemIdsRepo, previous) {
        return DefaultCompetitionRoundRulesSerializer(
          idsRepo: itemIdsRepo.last,
          teamCompetitionGroupRulesSerializer:
              TeamCompetitionGroupRulesSerializer(idsRepo: itemIdsRepo.last),
          entitiesLimitSerializer: EntitiesLimitSerializer(idsRepo: itemIdsRepo.last),
          positionsCreatorSerializer: StandingsPositionsCreatorSerializer(),
          koRoundRulesSerializer: KoRoundRulesSerializer(
            idsRepo: itemIdsRepo.last,
            advancementDeterminatorSerializer: KoRoundAdvancementDeterminatorSerializer(
              idsRepo: itemIdsRepo.last,
              entitiesLimitSerializer: EntitiesLimitSerializer(idsRepo: itemIdsRepo.last),
            ),
            koGroupsCreatorSerializer:
                KoGroupsCreatorSerializer(idsRepo: itemIdsRepo.last),
          ),
          windAveragerSerializer: WindAveragerSerializer(idsRepo: itemIdsRepo.last),
          judgesCreatorSerializer: JudgesCreatorSerializer(idsRepo: itemIdsRepo.last),
          competitionScoreCreatorSerializer:
              CompetitionScoreCreatorSerializer(idsRepo: itemIdsRepo.last),
          jumpScoreCreatorSerializer:
              JumpScoreCreatorSerializer(idsRepo: itemIdsRepo.last),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        SimulationDbPartParser<DefaultCompetitionRules>>(
      update: (context, itemIdsRepo, previous) {
        return DefaultCompetitionRulesParser(
          idsRepo: itemIdsRepo.last,
          roundRulesParser: context.read(), // Keep the round rules parser dependency
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        SimulationDbPartSerializer<DefaultCompetitionRules>>(
      update: (context, itemIdsRepo, previous) {
        return DefaultCompetitionRulesSerializer(
          idsRepo: itemIdsRepo.last,
          roundRulesSerializer:
              context.read(), // Keep the round rules serializer dependency
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        SimulationDbPartParser<DefaultCompetitionRulesProvider>>(
      update: (context, itemIdsRepo, previous) {
        return CompetitionRulesProviderParser(
          idsRepo: itemIdsRepo.last,
          rulesParser: context.read(), // Keep rules parser dependency
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        SimulationDbPartSerializer<DefaultCompetitionRulesProvider>>(
      update: (context, itemIdsRepo, previous) {
        return CompetitionRulesProviderSerializer(
          idsRepo: itemIdsRepo.last,
          rulesSerializer: context.read(), // Keep rules parser dependency
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        DbItemsJsonConfiguration<DefaultCompetitionRulesProvider>>(
      update: (context, itemIdsRepo, previous) {
        return DbItemsJsonConfiguration<DefaultCompetitionRulesProvider>(
          fromJson: (json) => context
              .read<SimulationDbPartParser<DefaultCompetitionRulesProvider>>()
              .parse(json),
          toJson: (provider) => context
              .read<SimulationDbPartSerializer<DefaultCompetitionRulesProvider>>()
              .serialize(provider),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        DbItemsJsonConfiguration<DefaultCompetitionRulesPreset>>(
      update: (context, itemIdsRepo, previous) {
        return DbItemsJsonConfiguration<DefaultCompetitionRulesPreset>(
          fromJson: (json) => CompetitionRulesPresetParser(
            idsRepo: itemIdsRepo.last,
            rulesParser: context.read(), // Keep rules parser dependency
          ).parse(json),
          toJson: (preset) => CompetitionRulesPresetSerializer(
            idsRepo: itemIdsRepo.last,
            rulesSerializer: context.read(), // Keep rules serializer dependency
          ).serialize(preset),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, SimulationDbPartParser<Competition>>(
      update: (context, itemIdsRepo, previous) {
        return CompetitionParser(
          idsRepo: itemIdsRepo.last,
          rulesParser: context.read(), // Keep rules parser dependency
          standingsParser: context.read(), // Keep standings parser dependency
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, SimulationDbPartSerializer<Competition>>(
      update: (context, itemIdsRepo, previous) {
        return CompetitionSerializer(
          idsRepo: itemIdsRepo.last,
          competitionRulesSerializer: context.read(), // Keep rules serializer dependency
          standingsSerializer: context.read(), // Keep standings serializer dependency
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, SimulationDbPartParser<EventSeries>>(
      update: (context, itemIdsRepo, previous) {
        return EventSeriesParser(
          idsRepo: itemIdsRepo.last,
          calendarParser: EventSeriesCalendarParser(
            idsRepo: itemIdsRepo.last,
            idGenerator: context.read(), // Keep idGenerator dependency
            competitionParser: context.read(), // Keep competition parser dependency
            classificationParser: context.read(), // Keep classification parser dependency
          ),
          setupParser: EventSeriesSetupParser(
            idsRepo: itemIdsRepo.last, // Pass updated idsRepo
          ),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, SimulationDbPartSerializer<EventSeries>>(
      update: (context, itemIdsRepo, previous) {
        return EventSeriesSerializer(
          idsRepo: itemIdsRepo.last,
          calendarSerializer: EventSeriesCalendarSerializer(
            idsRepo: itemIdsRepo.last,
            competitionSerializer:
                context.read(), // Keep competition serializer dependency
            classificationSerializer:
                context.read(), // Keep classification serializer dependency
          ),
          setupSerializer: EventSeriesSetupSerializer(
            idsRepo: itemIdsRepo.last, // Pass updated idsRepo
          ),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>, DbItemsJsonConfiguration<SimulationSeason>>(
      update: (context, itemIdsRepo, previous) {
        return DbItemsJsonConfiguration<SimulationSeason>(
          fromJson: (json) => SimulationSeasonParser(
            idsRepo: itemIdsRepo.last,
            eventSeriesParser: context.read(), // Keep eventSeriesParser dependency
          ).parse(json),
          toJson: (season) => SimulationSeasonSerializer(
            idsRepo: itemIdsRepo.last,
            eventSeriesSerializer:
                context.read(), // Keep eventSeriesSerializer dependency
          ).serialize(season),
        );
      },
    ),
    ProxyProvider<ValueRepo<ItemsIdsRepo>,
        DbItemsJsonConfiguration<EventSeriesCalendarPreset>>(
      update: (context, itemIdsRepo, previous) {
        return DbItemsJsonConfiguration<EventSeriesCalendarPreset>(
          fromJson: (json) => EventSeriesCalendarPresetParser(
            idsRepo: itemIdsRepo.last,
            highLevelCalendarParser: HighLevelCalendarParser(
              idsRepo: itemIdsRepo.last,
              idGenerator: context.read(), // Keep idGenerator dependency
              mainCompetitionRecordParser: MainCompetitionRecordParser(
                idsRepo: itemIdsRepo.last,
                idGenerator: context.read(), // Keep idGenerator dependency
                rulesProviderParser:
                    context.read(), // Keep rules provider parser dependency
              ),
              classificationParser:
                  context.read(), // Keep classification parser dependency
            ),
            lowLevelCalendarParser: EventSeriesCalendarParser(
              idsRepo: itemIdsRepo.last,
              idGenerator: context.read(), // Keep idGenerator dependency
              competitionParser: context.read(), // Keep competition parser dependency
              classificationParser:
                  context.read(), // Keep classification parser dependency
            ),
          ).parse(json),
          toJson: (preset) => EventSeriesCalendarPresetSerializer(
            idsRepo: itemIdsRepo.last,
            highLevelCalendarSerializer: HighLevelCalendarSerializer(
              idsRepo: itemIdsRepo.last,
              mainCompetitionRecordSerializer: MainCompetitionRecordSerializer(
                idsRepo: itemIdsRepo.last,
                rulesProviderSerializer: context.read(), // Keep rules provider serializer
              ),
              classificationSerializer:
                  context.read(), // Keep classification serializer dependency
            ),
            lowLevelCalendarSerializer: EventSeriesCalendarSerializer(
              idsRepo: itemIdsRepo.last,
              competitionSerializer:
                  context.read(), // Keep competition serializer dependency
              classificationSerializer:
                  context.read(), // Keep classification serializer dependency
            ),
          ).serialize(preset),
        );
      },
    ),
  ];
}
