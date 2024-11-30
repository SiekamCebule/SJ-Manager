import 'dart:async';

import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/countries/countries_repository/in_memory_countries_repository.dart';
import 'package:sj_manager/core/general_utils/json/countries.dart';
import 'package:sj_manager/core/general_utils/json/db_items_json.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/classification_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/classification_score_creator_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/competition_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/competition_round_rules_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/competition_score_creator_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/default_classification_rules_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/default_competition_rules_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/entities_limit_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/event_series_calendar_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/event_series_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/event_series_setup_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/judges_creator_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/jump_score_creator_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/ko_groups_creator_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/ko_round_advancement_determinator_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/ko_round_rules_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_season_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/standings_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/team_competition_group_rules_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/wind_averager_parser.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/simulations/data/models/simulation_database_model.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/manager_data/simulation_manager_data.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/general_utils/db_items_file_system_paths.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team_db_record.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/personal_coach_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/file_system.dart';

class DefaultSimulationDbLoaderFromFile {
  DefaultSimulationDbLoaderFromFile({
    required this.simulationId,
    required this.idsRepository,
    required this.pathsRegistry,
    required this.pathsCache,
  });

  late String _simulationId;
  late CountriesRepository _countriesRepo;
  late Json _dynamicStateJson;

  final String simulationId;
  final IdsRepository<String> idsRepository;
  final DbItemsFilePathsRegistry pathsRegistry;
  final PlarformSpecificPathsCache pathsCache;

  Future<SimulationDatabaseModel> load({
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

    final managerDataJson = _dynamicStateJson['managerData'] as Json;

    final personalCoachTeamJson = managerDataJson['personalCoachTeam'];
    final personalCoachTeam = personalCoachTeamJson != null
        ? PersonalCoachTeam.fromJson(
            personalCoachTeamJson,
            parseJumper: (id) => idsRepository.get(id),
          )
        : null;
    final personalCoachTeamId = managerDataJson['personalCoachTeamId'];
    if (personalCoachTeamId != null) {
      idsRepository.register(personalCoachTeam, id: personalCoachTeamId);
    }

    final String? userSubteamId = managerDataJson['userSubteamId'];
    final userSubteam = idsRepository.maybeGet<Subteam>(userSubteamId ?? '');

    final managerData = SimulationManagerData(
      mode: SimulationMode.values
          .singleWhere((mode) => mode.name == managerDataJson['simulationMode']),
      userSubteam: userSubteam,
      personalCoachTeam: personalCoachTeam,
    );

    final actionsJson = _dynamicStateJson['actions'] as List;
    final actions = actionsJson.map(
      (actionJson) {
        return SimulationAction(
          type: SimulationActionType.values
              .singleWhere((type) => type.name == actionJson['type']),
          deadline: actionJson['deadline'] != null
              ? DateTime.parse(actionJson['deadline'])
              : null,
          isCompleted: actionJson['isCompleted'],
        );
      },
    );

    return SimulationDatabaseModel(
      managerData: managerData,
      countryTeams: loadedCountryTeams.cast(),
      jumpers: loadedJumpers.cast(),
      hills: loadedHills.cast(),
      countries: _countriesRepo,
      seasons: loadedSeasons.cast(),
      startDate: DateTime.parse(_dynamicStateJson['startDate']!),
      currentDate: DateTime.parse(_dynamicStateJson['currentDate']!),
      idsRepository: idsRepository,
      actions: actions.toList(),
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
      idsRepository.register(itemAndCount.$1, id: id);
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
    } else if (type == CountryTeamDbRecord) {
      return pathsRegistry.get<CountryTeamDbRecord>();
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
    'countryTeam': CountryTeamDbRecord,
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
    } else if (type == CountryTeamDbRecord || type == Subteam) {
      return _parseTeam;
    } else if (type == SimulationSeason) {
      return _parseSeason;
    } else {
      throw TypeError();
    }
  }

  Future<SimulationJumper> _parseJumper(Json json) async {
    return await SimulationJumper.fromJson(json,
        countryLoader: JsonCountryLoaderByCode(countriesRepository: _countriesRepo));
  }

  Future<Hill> _parseHill(Json json) async {
    return await Hill.fromJson(json,
        countryLoader: JsonCountryLoaderByCode(countriesRepository: _countriesRepo));
  }

  Country _parseCountry(Json json) {
    return Country.fromJson(json);
  }

  Future<SimulationTeam> _parseTeam(Json json) async {
    return await SimulationTeamLoader(
            idsRepository: idsRepository,
            countryLoader: JsonCountryLoaderByCode(countriesRepository: _countriesRepo))
        .parse(json);
  }

  FutureOr<SimulationSeason> _parseSeason(Json json) async {
    final standingsParser = StandingsParser(
        idsRepository: idsRepository,
        scoreParser: ScoreParser(idsRepository: idsRepository),
        positionsCreatorParser: StandingsPositionsCreatorParser());
    return SimulationSeasonParser(
            idsRepository: idsRepository,
            eventSeriesParser: EventSeriesParser(
                idsRepository: idsRepository,
                calendarParser: EventSeriesCalendarParser(
                    idsRepository: idsRepository,
                    competitionParser: CompetitionParser(
                        idsRepository: idsRepository,
                        rulesParser: DefaultCompetitionRulesParser(
                            idsRepository: idsRepository,
                            roundRulesParser: CompetitionRoundRulesParser(
                                idsRepository: idsRepository,
                                entitiesLimitParser:
                                    EntitiesLimitParser(idsRepository: idsRepository),
                                positionsCreatorParser: StandingsPositionsCreatorParser(),
                                teamCompetitionGroupRulesParser: TeamCompetitionGroupRulesParser(
                                    idsRepository: idsRepository),
                                koRoundRulesParser: KoRoundRulesParser(
                                    idsRepository: idsRepository,
                                    advancementDeterminatorParser: KoRoundAdvancementDeterminatorLoader(
                                        idsRepository: idsRepository,
                                        entitiesLimitParser: EntitiesLimitParser(
                                            idsRepository: idsRepository)),
                                    koGroupsCreatorParser: KoGroupsCreatorLoader(
                                        idsRepository: idsRepository)),
                                windAveragerParser:
                                    WindAveragerParser(idsRepository: idsRepository),
                                judgesCreatorParser:
                                    JudgesCreatorLoader(idsRepository: idsRepository),
                                competitionScoreCreatorParser: CompetitionScoreCreatorLoader(
                                    idsRepository: idsRepository),
                                jumpScoreCreatorParser: JumpScoreCreatorLoader(
                                    idsRepository: idsRepository))),
                        standingsParser: standingsParser),
                    classificationParser: ClassificationParser(
                        idsRepository: idsRepository,
                        standingsParser: standingsParser,
                        defaultClassificationRulesParser: DefaultClassificationRulesParser(idsRepository: idsRepository, classificationScoreCreatorParser: ClassificationScoreCreatorParser(idsRepository: idsRepository)))),
                setupParser: EventSeriesSetupParser(idsRepository: idsRepository)))
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
