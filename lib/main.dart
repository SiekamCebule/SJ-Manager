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
import 'package:sj_manager/json/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/standings_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/team_competition_group_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/team_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/wind_averager_serializer.dart';
import 'package:sj_manager/models/game_variants/game_variant.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_preset.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_provider.dart';
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
import 'package:sj_manager/repositories/countries/country_flags/country_flags_repo.dart';
import 'package:sj_manager/repositories/countries/country_flags/local_storage_country_flags_repo.dart';
import 'package:sj_manager/repositories/generic/editable_items_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';
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
            RepositoryProvider<CountryFlagsRepo>(
              create: (context) {
                final storageDirectory = userDataDirectory(
                    pathsCache, path.join('database', 'countries', 'country_flags'));
                return LocalStorageCountryFlagsRepo(
                  imagesDirectory: storageDirectory,
                  imagesExtension: 'png',
                );
              },
            ),
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
              Provider(
                create: (context) => DbItemsFilePathsRegistry(initial: {
                  MaleJumper: 'jumpers_male.json',
                  FemaleJumper: 'jumpers_female.json',
                  /*Hill: 'hills.json',
                  EventSeriesSetup: 'event_series_setups.json',
                  EventSeriesCalendarPreset: 'event_series_calendar_presets.json',
                  DefaultCompetitionRulesPreset: 'default_competition_rules_presets.json',*/
                  Country: path.join('countries', 'countries.json'),
                  Team: path.join('teams', 'teams.json'),
                }),
              ),
              Provider(
                create: (context) => DbItemsDirectoryPathsRegistry(
                  initial: {
                    CountryFlag: path.join('countries', 'country_flags'),
                  },
                ),
              ),
              Provider<ItemsIdsRepo>(create: (context) {
                return ItemsIdsRepo<String>();
              }),
              Provider<IdGenerator>(create: (context) {
                return const NanoIdGenerator(size: 15);
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
                    return Country.fromJson(json);
                  },
                  toJson: (hill) => throw UnimplementedError(),
                );
              }),
              Provider(create: (context) {
                return DbItemsJsonConfiguration<Team>(
                  fromJson: (json) => TeamLoader(
                    idsRepo: context.read(),
                    countryLoader: JsonCountryLoaderByCode(repo: countriesRepo(context)),
                  ).parse(json),
                  toJson: (team) => TeamSerializer(
                    idsRepo: context.read(),
                  ).serialize(team),
                );
              }),
              Provider(create: (context) {
                return DbItemsJsonConfiguration<EventSeriesSetup>(
                  fromJson: (json) =>
                      EventSeriesSetupParser(idsRepo: context.read()).parse(json),
                  toJson: (series) => EventSeriesSetupSerializer(idsRepo: context.read())
                      .serialize(series),
                );
              }),
              Provider<SimulationDbPartParser<DefaultCompetitionRoundRules>>(
                  create: (context) => CompetitionRoundRulesParser(
                        idsRepo: context.read(),
                        entitiesLimitParser: EntitiesLimitParser(idsRepo: context.read()),
                        positionsCreatorParser: StandingsPositionsCreatorParser(),
                        teamCompetitionGroupRulesParser:
                            TeamCompetitionGroupRulesParser(idsRepo: context.read()),
                        koRoundRulesParser: KoRoundRulesParser(
                          idsRepo: context.read(),
                          advancementDeterminatorParser:
                              KoRoundAdvancementDeterminatorLoader(
                                  idsRepo: context.read(),
                                  entitiesLimitParser: EntitiesLimitParser(
                                    idsRepo: context.read(),
                                  )),
                          koGroupsCreatorParser:
                              KoGroupsCreatorLoader(idsRepo: context.read()),
                        ),
                        windAveragerParser: WindAveragerParser(idsRepo: context.read()),
                        judgesCreatorParser: JudgesCreatorLoader(idsRepo: context.read()),
                        competitionScoreCreatorParser:
                            CompetitionScoreCreatorLoader(idsRepo: context.read()),
                        jumpScoreCreatorParser:
                            JumpScoreCreatorLoader(idsRepo: context.read()),
                      )),
              Provider<SimulationDbPartSerializer<DefaultCompetitionRoundRules>>(
                create: (context) => DefaultCompetitionRoundRulesSerializer(
                  idsRepo: context.read(),
                  teamCompetitionGroupRulesSerializer:
                      TeamCompetitionGroupRulesSerializer(idsRepo: context.read()),
                  entitiesLimitSerializer:
                      EntitiesLimitSerializer(idsRepo: context.read()),
                  positionsCreatorSerializer: StandingsPositionsCreatorSerializer(),
                  koRoundRulesSerializer: KoRoundRulesSerializer(
                    idsRepo: context.read(),
                    advancementDeterminatorSerializer:
                        KoRoundAdvancementDeterminatorSerializer(
                      idsRepo: context.read(),
                      entitiesLimitSerializer: EntitiesLimitSerializer(
                        idsRepo: context.read(),
                      ),
                    ),
                    koGroupsCreatorSerializer:
                        KoGroupsCreatorSerializer(idsRepo: context.read()),
                  ),
                  windAveragerSerializer: WindAveragerSerializer(idsRepo: context.read()),
                  judgesCreatorSerializer:
                      JudgesCreatorSerializer(idsRepo: context.read()),
                  competitionScoreCreatorSerializer:
                      CompetitionScoreCreatorSerializer(idsRepo: context.read()),
                  jumpScoreCreatorSerializer:
                      JumpScoreCreatorSerializer(idsRepo: context.read()),
                ),
              ),
              Provider<SimulationDbPartParser<DefaultCompetitionRules>>(
                  create: (context) => DefaultCompetitionRulesParser(
                      idsRepo: context.read(), roundRulesParser: context.read())),
              Provider<SimulationDbPartSerializer<DefaultCompetitionRules>>(
                  create: (context) => DefaultCompetitionRulesSerializer(
                      idsRepo: context.read(), roundRulesSerializer: context.read())),
              Provider(create: (context) {
                return DbItemsJsonConfiguration<DefaultCompetitionRulesProvider>(
                  fromJson: (json) => CompetitionRulesProviderParser(
                    idsRepo: context.read(),
                    rulesParser: context.read(),
                  ).parse(json),
                  toJson: (provider) => CompetitionRulesProviderSerializer(
                    idsRepo: context.read(),
                    rulesSerializer: context.read(),
                  ).serialize(provider),
                );
              }),
              Provider<SimulationDbPartSerializer<DefaultCompetitionRulesProvider>>(
                create: (context) => CompetitionRulesProviderSerializer(
                  idsRepo: context.read(),
                  rulesSerializer: context.read(),
                ),
              ),
              Provider<SimulationDbPartParser<DefaultCompetitionRulesProvider>>(
                create: (context) => CompetitionRulesProviderParser(
                  idsRepo: context.read(),
                  rulesParser: context.read(),
                ),
              ),
              Provider<SimulationDbPartParser<Standings>>(create: (context) {
                return StandingsParser(
                  idsRepo: context.read(),
                  idGenerator: context.read(),
                  scoreParser: ScoreParser(
                    idsRepo: context.read(),
                  ),
                  positionsCreatorParser: StandingsPositionsCreatorParser(),
                );
              }),
              Provider<SimulationDbPartSerializer<Standings>>(create: (context) {
                return StandingsSerializer(
                  idsRepo: context.read(),
                  scoreSerializer: ScoreSerializer(
                    idsRepo: context.read(),
                  ),
                  positionsCreatorSerializer: StandingsPositionsCreatorSerializer(),
                );
              }),
              Provider<SimulationDbPartParser<Classification>>(
                create: (context) => ClassificationParser(
                  idsRepo: context.read(),
                  standingsParser: context.read(),
                  defaultClassificationRulesParser: DefaultClassificationRulesParser(
                    idsRepo: context.read(),
                    classificationScoreCreatorParser:
                        ClassificationScoreCreatorParser(idsRepo: context.read()),
                  ),
                ),
              ),
              Provider<SimulationDbPartSerializer<Classification>>(
                create: (context) => ClassificationSerializer(
                  idsRepo: context.read(),
                  standingsSerializer: context.read(),
                  defaultClassificationRulesSerializer:
                      DefaultClassificationRulesSerializer(
                    idsRepo: context.read(),
                    classificationScoreCreatorSerializer:
                        ClassificationScoreCreatorSerializer(idsRepo: context.read()),
                  ),
                ),
              ),
              Provider(create: (context) {
                return DbItemsJsonConfiguration<EventSeriesCalendarPreset>(
                  fromJson: (json) => EventSeriesCalendarPresetParser(
                    idsRepo: context.read(),
                    highLevelCalendarParser: HighLevelCalendarParser(
                      idsRepo: context.read(),
                      idGenerator: context.read(),
                      mainCompetitionRecordParser: MainCompetitionRecordParser(
                        idsRepo: context.read(),
                        idGenerator: context.read(),
                        rulesProviderParser: context.read(),
                      ),
                      classificationParser: context.read(),
                    ),
                    lowLevelCalendarParser: EventSeriesCalendarParser(
                      idsRepo: context.read(),
                      idGenerator: context.read(),
                      competitionParser: CompetitionParser(
                        idsRepo: context.read(),
                        rulesParser: context.read(),
                        standingsParser: context.read(),
                      ),
                      classificationParser: context.read(),
                    ),
                  ).parse(json),
                  toJson: (preset) => EventSeriesCalendarPresetSerializer(
                    idsRepo: context.read(),
                    highLevelCalendarSerializer: HighLevelCalendarSerializer(
                      idsRepo: context.read(),
                      mainCompetitionRecordSerializer: MainCompetitionRecordSerializer(
                        idsRepo: context.read(),
                        rulesProviderSerializer: context.read(),
                      ),
                      classificationSerializer: context.read(),
                    ),
                    lowLevelCalendarSerializer: EventSeriesCalendarSerializer(
                      idsRepo: context.read(),
                      competitionSerializer: CompetitionSerializer(
                          idsRepo: context.read(),
                          competitionRulesSerializer: context.read(),
                          standingsSerializer: context.read()),
                      classificationSerializer: context.read(),
                    ),
                  ).serialize(preset),
                );
              }),
              Provider(create: (context) {
                return DbItemsJsonConfiguration<DefaultCompetitionRulesPreset>(
                  fromJson: (json) => CompetitionRulesPresetParser(
                    idsRepo: context.read(),
                    rulesParser: context.read(),
                  ).parse(json),
                  toJson: (preset) => CompetitionRulesPresetSerializer(
                    idsRepo: context.read(),
                    rulesSerializer: context.read(),
                  ).serialize(preset),
                );
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
