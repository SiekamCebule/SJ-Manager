import 'dart:async';

import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/countries/countries_repository/in_memory_countries_repository.dart';
import 'package:sj_manager/utilities/json/countries.dart';
import 'package:sj_manager/utilities/json/db_items_json.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/classification_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/classification_score_creator_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/competition_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/competition_round_rules_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/competition_score_creator_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/default_classification_rules_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/default_competition_rules_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/entities_limit_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/event_series_calendar_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/event_series_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/event_series_setup_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/judges_creator_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/jump_score_creator_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/ko_groups_creator_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/ko_round_advancement_determinator_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/ko_round_rules_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_season_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/standings_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/team_competition_group_rules_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/team_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/wind_averager_parser.dart';
import 'package:sj_manager/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/domain/entities/simulation/database/actions/simulation_actions_repo.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_manager_data.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/domain/entities/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/data/repositories/db_items_file_system_paths.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';
import 'package:sj_manager/core/classes/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam_type.dart';
import 'package:sj_manager/domain/entities/simulation/team/personal_coach_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';
import 'package:sj_manager/utilities/utils/file_system.dart';
import 'package:sj_manager/utilities/utils/id_generator.dart';

class DefaultSimulationDbLoaderFromFile {
  DefaultSimulationDbLoaderFromFile({
    required this.idsRepo,
    required this.idGenerator,
    required this.pathsRegistry,
    required this.pathsCache,
  });

  late String _simulationId;
  late CountriesRepository _countriesRepo;
  late Json _dynamicStateJson;

  final ItemsIdsRepo<String> idsRepo;
  final IdGenerator idGenerator;
  final DbItemsFilePathsRegistry pathsRegistry;
  final PlarformSpecificPathsCache pathsCache;

  Future<SimulationDatabase> load({
    required String simulationId,
  }) async {
    _simulationId = simulationId;

    final loadedCountriesMap = await _loadItems(itemsType: 'country');
    _addIdsFromLoadedMap(loadedCountriesMap);
    final loadedCountries = _itemsFromLoadedMap(loadedCountriesMap);
    _countriesRepo = InMemoryCountriesRepository(countries: loadedCountries.cast());

    final loadedMaleJumpersMap = await _loadItems(itemsType: 'maleJumper');
    _addIdsFromLoadedMap(loadedMaleJumpersMap);
    final loadedMaleJumpers = _itemsFromLoadedMap(loadedMaleJumpersMap);

    final loadedFemaleJumpersMap = await _loadItems(itemsType: 'femaleJumper');
    _addIdsFromLoadedMap(loadedFemaleJumpersMap);
    final loadedFemaleJumpers = _itemsFromLoadedMap(loadedFemaleJumpersMap);

    final loadedJumpers = [
      ...loadedMaleJumpers,
      ...loadedFemaleJumpers,
    ].cast<SimulationJumper>();

    final loadedHillsMap = await _loadItems(itemsType: 'hill');
    _addIdsFromLoadedMap(loadedHillsMap);
    final loadedHills = _itemsFromLoadedMap(loadedHillsMap);

    final loadedCountryTeamsMap = await _loadItems(itemsType: 'countryTeam');
    _addIdsFromLoadedMap(loadedCountryTeamsMap);
    final loadedCountryTeams = _itemsFromLoadedMap(loadedCountryTeamsMap);

    final loadedSeasonMap = await _loadItems(itemsType: 'simulationSeason');
    _addIdsFromLoadedMap(loadedSeasonMap);
    final loadedSeasons = _itemsFromLoadedMap(loadedSeasonMap);

    _dynamicStateJson = await _loadDynamicStateJson();

    final actionDeadlinesJson = _dynamicStateJson['actionDeadlines'] as Map;
    final actionDeadlines = actionDeadlinesJson.map((actionTypeName, dateTimeJson) {
      return MapEntry(
        SimulationActionType.values.singleWhere((value) => value.name == actionTypeName),
        DateTime.parse(dateTimeJson),
      );
    });

    final simulationActionCompletionStatusesJson =
        _dynamicStateJson['simulationActionCompletionStatuses'] as List;

    final simulationActionCompletionStatuses =
        simulationActionCompletionStatusesJson.map((actionTypeName) {
      return SimulationActionType.values
          .singleWhere((value) => value.name == actionTypeName);
    }).toSet();

    final managerDataJson = _dynamicStateJson['managerData'] as Json;

    final personalCoachTeamJson = managerDataJson['personalCoachTeam'];
    final personalCoachTeam = personalCoachTeamJson != null
        ? PersonalCoachTeam.fromJson(
            personalCoachTeamJson,
            parseJumper: (id) => idsRepo.get(id),
          )
        : null;
    final personalCoachTeamId = managerDataJson['personalCoachTeamId'];
    if (personalCoachTeamId != null) {
      idsRepo.register(personalCoachTeam, id: personalCoachTeamId);
    }

    final String? userSubteamId = managerDataJson['userSubteamId'];
    final userSubteam = idsRepo.maybeGet<Subteam>(userSubteamId ?? '');

    final managerData = SimulationManagerData(
      mode: SimulationMode.values
          .singleWhere((mode) => mode.name == managerDataJson['simulationMode']),
      userSubteam: userSubteam,
      personalCoachTeam: personalCoachTeam,
    );

    final teamReportsJson = _dynamicStateJson['teamReports'] as Map;
    final teamReports = teamReportsJson.map((id, reportsJson) {
      return MapEntry(
        id,
        TeamReports.fromJson(reportsJson),
      );
    });

    final subteamJumpersJson = _dynamicStateJson['subteamJumpers'] as Json;
    final subteamJumpers = subteamJumpersJson.map((subteamKey, jumperIds) {
      final splitSubteamKey = subteamKey.split('###');
      return MapEntry(
        Subteam(
          type:
              SubteamType.values.singleWhere((value) => value.name == splitSubteamKey[0]),
          parentTeam: idsRepo.get(splitSubteamKey[1]),
        ),
        (jumperIds as List).toList().cast<String>(),
      );
    });

    return SimulationDatabase(
      managerData: managerData,
      countryTeams: loadedCountryTeams.cast(),
      jumpers: loadedJumpers.cast(),
      hills: loadedHills.cast(),
      countries: _countriesRepo,
      seasons: loadedSeasons.cast(),
      startDate: DateTime.parse(_dynamicStateJson['startDate']!),
      currentDate: DateTime.parse(_dynamicStateJson['currentDate']!),
      idsRepo: idsRepo,
      actionDeadlines: actionDeadlines,
      actionsRepo: SimulationActionsRepo(initial: simulationActionCompletionStatuses),
      teamReports: teamReports.cast(),
      subteamJumpers: subteamJumpers.cast(),
    );
  }

  List<T> _itemsFromLoadedMap<T>(LoadedItemsMap<T> map) {
    final itemsById = map.items.map((id, itemAndCount) => MapEntry(id, itemAndCount.$1));
    return map.orderedIds.map((id) {
      return itemsById[id]!;
    }).toList();
  }

  void _addIdsFromLoadedMap(LoadedItemsMap map) {
    map.items.forEach((id, itemAndCount) {
      idsRepo.register(itemAndCount.$1, id: id);
    });
  }

  Future<Json> _loadDynamicStateJson() async {
    final file = simulationFile(
      pathsCache: pathsCache,
      simulationId: _simulationId,
      fileName: 'dynamic_state.json',
    );
    final json = safeJsonDecode(await file.readAsString()) as Json;
    return json;
  }

  Future<LoadedItemsMap> _loadItems({required String itemsType}) async {
    final mappedType = _itemsTypeStringToType[itemsType]!;
    final fileName = _getFilePath(type: mappedType);
    final file = simulationFile(
        pathsCache: pathsCache, simulationId: _simulationId, fileName: fileName);
    final json = safeJsonDecode(await file.readAsString()) as Json;
    final parse = _appropriateParseFunction(json: json, type: mappedType);
    final items = await loadItemsMapFromJsonFile(file: file, fromJson: parse);
    return items;
  }

  String _getFilePath({required Type type}) {
    if (type == SimulationMaleJumper) {
      return pathsRegistry.get<SimulationMaleJumper>();
    } else if (type == SimulationFemaleJumper) {
      return pathsRegistry.get<SimulationFemaleJumper>();
    } else if (type == Hill) {
      return pathsRegistry.get<Hill>();
    } else if (type == Country) {
      return pathsRegistry.get<Country>();
    } else if (type == CountryTeam) {
      return pathsRegistry.get<CountryTeam>();
    } else if (type == Subteam) {
      return pathsRegistry.get<Subteam>();
    } else if (type == SimulationSeason) {
      return pathsRegistry.get<SimulationSeason>();
    } else {
      throw TypeError();
    }
  }

  static const _itemsTypeStringToType = {
    'maleJumper': SimulationMaleJumper,
    'femaleJumper': SimulationFemaleJumper,
    'hill': Hill,
    'country': Country,
    'countryTeam': CountryTeam,
    'subteam': Subteam,
    'simulationSeason': SimulationSeason,
  };

  dynamic Function(Json json) _appropriateParseFunction({
    required Json json,
    required Type type,
  }) {
    if (type == SimulationMaleJumper) {
      return _parseJumper;
    } else if (type == SimulationFemaleJumper) {
      return _parseJumper;
    } else if (type == Hill) {
      return _parseHill;
    } else if (type == Country) {
      return _parseCountry;
    } else if (type == CountryTeam || type == Subteam) {
      return _parseTeam;
    } else if (type == SimulationSeason) {
      return _parseSeason;
    } else {
      throw TypeError();
    }
  }

  SimulationJumper _parseJumper(Json json) {
    return SimulationJumper.fromJson(json,
        countryLoader: JsonCountryLoaderByCode(countriesRepository: _countriesRepo));
  }

  Hill _parseHill(Json json) {
    return Hill.fromJson(json,
        countryLoader: JsonCountryLoaderByCode(countriesRepository: _countriesRepo));
  }

  Country _parseCountry(Json json) {
    return Country.fromJson(json);
  }

  Team _parseTeam(Json json) {
    return TeamLoader(
            idsRepo: idsRepo,
            countryLoader: JsonCountryLoaderByCode(countriesRepository: _countriesRepo))
        .parse(json);
  }

  FutureOr<SimulationSeason> _parseSeason(Json json) async {
    final standingsParser = StandingsParser(
        idsRepo: idsRepo,
        idGenerator: idGenerator,
        scoreParser: ScoreParser(idsRepo: idsRepo),
        positionsCreatorParser: StandingsPositionsCreatorParser());
    return SimulationSeasonParser(
            idsRepo: idsRepo,
            eventSeriesParser: EventSeriesParser(
                idsRepo: idsRepo,
                calendarParser: EventSeriesCalendarParser(
                    idsRepo: idsRepo,
                    idGenerator: idGenerator,
                    competitionParser: CompetitionParser(
                        idsRepo: idsRepo,
                        rulesParser: DefaultCompetitionRulesParser(
                            idsRepo: idsRepo,
                            roundRulesParser: CompetitionRoundRulesParser(
                                idsRepo: idsRepo,
                                entitiesLimitParser:
                                    EntitiesLimitParser(idsRepo: idsRepo),
                                positionsCreatorParser: StandingsPositionsCreatorParser(),
                                teamCompetitionGroupRulesParser:
                                    TeamCompetitionGroupRulesParser(idsRepo: idsRepo),
                                koRoundRulesParser: KoRoundRulesParser(
                                    idsRepo: idsRepo,
                                    advancementDeterminatorParser:
                                        KoRoundAdvancementDeterminatorLoader(
                                            idsRepo: idsRepo,
                                            entitiesLimitParser:
                                                EntitiesLimitParser(idsRepo: idsRepo)),
                                    koGroupsCreatorParser:
                                        KoGroupsCreatorLoader(idsRepo: idsRepo)),
                                windAveragerParser: WindAveragerParser(idsRepo: idsRepo),
                                judgesCreatorParser:
                                    JudgesCreatorLoader(idsRepo: idsRepo),
                                competitionScoreCreatorParser:
                                    CompetitionScoreCreatorLoader(idsRepo: idsRepo),
                                jumpScoreCreatorParser:
                                    JumpScoreCreatorLoader(idsRepo: idsRepo))),
                        standingsParser: standingsParser),
                    classificationParser: ClassificationParser(
                        idsRepo: idsRepo,
                        standingsParser: standingsParser,
                        defaultClassificationRulesParser:
                            DefaultClassificationRulesParser(
                                idsRepo: idsRepo,
                                classificationScoreCreatorParser:
                                    ClassificationScoreCreatorParser(idsRepo: idsRepo)))),
                setupParser: EventSeriesSetupParser(idsRepo: idsRepo)))
        .parse(json);
  }

  // TODO: Can I load it concurrently?
  /*Future<List<SimulationSeason>> _loadSeasons() async {
    final fileName = _context.read<DbItemsFilePathsRegistry>().get<SimulationDatabase>();
    final file = simulationFile(
        pathsCache: _context.read(), simulationId: _simulationId, fileName: fileName);
    final jsonContent = await file.readAsString();
    final seasonsJson = (safeJsonDecode(jsonContent) as List<dynamic>).cast<Json>();
    final seasonFutures = seasonsJson.map((seasonJson) async {
      return await _parseSingleSeason(seasonJson);
    }).toList();

    final seasons = await Future.wait(seasonFutures);
    return seasons;
  }*/
}
