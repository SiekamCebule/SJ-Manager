import 'dart:async';
import 'dart:convert';
import 'package:sj_manager/core/general_utils/json/countries.dart';
import 'package:sj_manager/core/general_utils/json/db_items_json.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/classification_score_creator_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/classification_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/competition_rules_provider_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/competition_score_creator_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/competition_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/default_classification_rules_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/default_competition_round_rules_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/default_competition_rules_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/entities_limit_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/event_series_calendar_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/event_series_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/event_series_setup_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/judges_creator_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/jump_score_creator_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/ko_groups_creator_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/ko_round_advancement_determinator_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/ko_round_rules_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/score_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_season_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/standings_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/team_competition_group_rules_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/team_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/wind_averager_serializer.dart';
import 'package:sj_manager/features/simulations/data/models/simulation_database_model.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/general_utils/db_items_file_system_paths.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/file_system.dart';

class DefaultSimulationDatabaseSaverToFile {
  DefaultSimulationDatabaseSaverToFile({
    required this.pathsRegistry,
    required this.pathsCache,
    required this.idsRepository,
    required this.simulationId,
  });

  final DbItemsFilePathsRegistry pathsRegistry;
  final PlarformSpecificPathsCache pathsCache;
  final IdsRepository idsRepository;
  final String simulationId;

  late SimulationDatabaseModel _database;

  Future<void> serialize({
    required SimulationDatabaseModel database,
  }) async {
    _database = database;
    await _serializeItems(items: database.maleJumpers, itemsType: 'maleJumper');
    await _serializeItems(items: database.femaleJumpers, itemsType: 'femaleJumper');
    await _serializeItems(items: database.hills, itemsType: 'hill');
    await _serializeItems(items: await database.countries.getAll(), itemsType: 'country');
    await _serializeItems(items: database.countryTeams, itemsType: 'countryTeam');
    await _serializeItems(items: database.seasons, itemsType: 'simulationSeason');
    await _serializeDynamicState();
  }

  Future<void> _serializeDynamicState() async {
    final file = simulationFile(
      pathsCache: pathsCache,
      simulationId: simulationId,
      fileName: 'dynamic_state.json',
    );
    await file.create(recursive: true);
    final subteamJumpersJson = _database.subteamJumpers.map((subteam, jumperIds) {
      return MapEntry(
        '${subteam.type.name}###${idsRepository.id(subteam.parentTeam)}',
        jumperIds.toList(),
      );
    });
    final json = {
      'managerData': {
        'simulationMode': _database.managerData.mode.name,
        'userSubteamId': idsRepository.maybeIdOf(_database.managerData.userSubteam),
        'personalCoachTeam': _database.managerData.personalCoachTeam
            ?.toJson(serializeJumper: (jumper) => idsRepository.id(jumper)),
        'personalCoachTeamId':
            idsRepository.maybeIdOf(_database.managerData.personalCoachTeam),
      },
      'startDate': _database.startDate.toString(),
      'currentDate': _database.currentDate.toString(),
      'actionDeadlines': _database.actionDeadlines.map(
        (actionType, dateTime) => MapEntry(actionType.name, dateTime.toString()),
      ),
      'simulationActionCompletionStatuses': _database.actionsRepo.completedActions
          .map((actionType) => actionType.name)
          .toList(),
      'teamReports': _database.teamReports.map((id, reports) {
        return MapEntry(id, reports.toJson());
      }),
      'subteamJumpers': subteamJumpersJson,
    };
    await file.writeAsString(jsonEncode(json));
  }

  Future<void> _serializeItems<T>({
    required Iterable<T> items,
    required String itemsType,
  }) async {
    final mappedType = _itemsTypeStringToType[itemsType]!;
    final fileName = _getFilePath(type: mappedType);
    final file = simulationFile(
        pathsCache: pathsCache, simulationId: simulationId, fileName: fileName);
    final toJson = _appropriateSerializeFunction(type: mappedType);
    await file.create(recursive: true);
    await saveItemsMapToJsonFile(
      file: file,
      items: items,
      toJson: toJson,
      idsRepository: idsRepository,
    );
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

  FutureOr<Json> Function(dynamic json) _appropriateSerializeFunction({
    required Type type,
  }) {
    if (type == SimulationMaleJumper) {
      return (item) => _serializeJumper(item);
    } else if (type == SimulationFemaleJumper) {
      return (item) => _serializeJumper(item);
    } else if (type == Hill) {
      return (item) => _serializeHill(item);
    } else if (type == Country) {
      return (item) => _serializeCountry(item);
    } else if (type == CountryTeam || type == Subteam) {
      return (item) => _serializeTeam(item);
    } else if (type == SimulationSeason) {
      return (item) async => await _serializeSeason(item);
    } else {
      throw TypeError();
    }
  }

  Json _serializeJumper(SimulationJumper item) {
    return item.toJson(countrySaver: const JsonCountryCodeSaver());
  }

  Json _serializeHill(Hill item) {
    return item.toJson(countrySaver: const JsonCountryCodeSaver());
  }

  Json _serializeCountry(Country item) {
    return item.toJson();
  }

  Json _serializeTeam(Team item) {
    return TeamSerializer(idsRepository: idsRepository).serialize(item);
  }

  Future<Json> _serializeSeason(SimulationSeason season) async {
    final standingsSerializer = StandingsSerializer(
        idsRepository: idsRepository,
        scoreSerializer: ScoreSerializer(idsRepository: idsRepository),
        positionsCreatorSerializer: StandingsPositionsCreatorSerializer());
    return await SimulationSeasonSerializer(
            idsRepository: idsRepository,
            eventSeriesSerializer: EventSeriesSerializer(
                idsRepository: idsRepository,
                calendarSerializer: EventSeriesCalendarSerializer(
                    idsRepository: idsRepository,
                    competitionSerializer: CompetitionSerializer(
                        idsRepository: idsRepository,
                        competitionRulesSerializer: CompetitionRulesProviderSerializer(
                            idsRepository: idsRepository,
                            rulesSerializer: DefaultCompetitionRulesSerializer(
                                idsRepository: idsRepository,
                                roundRulesSerializer: DefaultCompetitionRoundRulesSerializer(
                                    idsRepository: idsRepository,
                                    teamCompetitionGroupRulesSerializer:
                                        TeamCompetitionGroupRulesSerializer(
                                            idsRepository: idsRepository),
                                    entitiesLimitSerializer: EntitiesLimitSerializer(
                                        idsRepository: idsRepository),
                                    positionsCreatorSerializer:
                                        StandingsPositionsCreatorSerializer(),
                                    koRoundRulesSerializer: KoRoundRulesSerializer(
                                        idsRepository: idsRepository,
                                        advancementDeterminatorSerializer:
                                            KoRoundAdvancementDeterminatorSerializer(
                                                idsRepository: idsRepository,
                                                entitiesLimitSerializer:
                                                    EntitiesLimitSerializer(
                                                        idsRepository: idsRepository)),
                                        koGroupsCreatorSerializer:
                                            KoGroupsCreatorSerializer(idsRepository: idsRepository)),
                                    windAveragerSerializer: WindAveragerSerializer(idsRepository: idsRepository),
                                    judgesCreatorSerializer: JudgesCreatorSerializer(idsRepository: idsRepository),
                                    jumpScoreCreatorSerializer: JumpScoreCreatorSerializer(idsRepository: idsRepository),
                                    competitionScoreCreatorSerializer: CompetitionScoreCreatorSerializer(idsRepository: idsRepository)))),
                        standingsSerializer: standingsSerializer),
                    classificationSerializer: ClassificationSerializer(idsRepository: idsRepository, standingsSerializer: standingsSerializer, defaultClassificationRulesSerializer: DefaultClassificationRulesSerializer(idsRepository: idsRepository, classificationScoreCreatorSerializer: ClassificationScoreCreatorSerializer(idsRepository: idsRepository)))),
                setupSerializer: EventSeriesSetupSerializer(idsRepository: idsRepository)))
        .serialize(season);
  }
}
