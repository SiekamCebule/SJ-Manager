import 'dart:async';
import 'dart:convert';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/db_items_json.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/json/simulation_db_saving/classification_score_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/classification_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/competition_rules_provider_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/competition_score_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/competition_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/default_classification_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/default_competition_round_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/default_competition_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/entities_limit_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/event_series_calendar_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/event_series_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/event_series_setup_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/judges_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/jump_score_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/ko_groups_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/ko_round_advancement_determinator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/ko_round_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/score_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/simulation_season_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/standings_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/team_competition_group_rules_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/team_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/wind_averager_serializer.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/db_items_file_system_paths.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/file_system.dart';

class DefaultSimulationDatabaseSaverToFile {
  DefaultSimulationDatabaseSaverToFile({
    required this.pathsRegistry,
    required this.pathsCache,
    required this.idsRepo,
    required this.simulationId,
  });

  final DbItemsFilePathsRegistry pathsRegistry;
  final PlarformSpecificPathsCache pathsCache;
  final ItemsIdsRepo idsRepo;
  final String simulationId;

  late SimulationDatabase _database;

  Future<void> serialize({
    required SimulationDatabase database,
  }) async {
    _database = database;
    await _serializeItems(items: database.maleJumpers.toList(), itemsType: 'maleJumper');
    await _serializeItems(
        items: database.femaleJumpers.toList(), itemsType: 'femaleJumper');
    await _serializeItems(items: database.hills.last.toList(), itemsType: 'hill');
    await _serializeItems(items: database.countries.last.toList(), itemsType: 'country');
    await _serializeItems(
        items: database.countryTeams.last.toList(), itemsType: 'countryTeam');
    await _serializeItems(items: database.subteams.last.toList(), itemsType: 'subteam');
    await _serializeItems(
        items: database.seasons.last.toList(), itemsType: 'simulationSeason');
    await _serializeDynamicState();
  }

  Future<void> _serializeDynamicState() async {
    final file = simulationFile(
      pathsCache: pathsCache,
      simulationId: simulationId,
      fileName: 'dynamic_state.json',
    );
    await file.create(recursive: true);
    final json = {
      'managerData': {
        'simulationMode': _database.managerData.mode.name,
        'userSubteamId': idsRepo.maybeIdOf(_database.managerData.userSubteam),
        'personalCoachTeam': _database.managerData.personalCoachTeam
            ?.toJson(serializeJumper: (jumper) => idsRepo.idOf(jumper)),
        'personalCoachTeamId': idsRepo.maybeIdOf(_database.managerData.personalCoachTeam),
      },
      'startDate': _database.startDate.toString(),
      'currentDate': _database.currentDate.toString(),
      'jumpersDynamicParameters': _database.jumperDynamicParams.map(
        (jumper, params) => MapEntry(idsRepo.idOf(jumper), params.toJson()),
      ),
      'actionDeadlines': _database.actionDeadlines.map(
        (actionType, dateTime) => MapEntry(actionType.name, dateTime.toString()),
      ),
      'simulationActionCompletionStatuses': _database.actionsRepo.completedActions
          .map((actionType) => actionType.name)
          .toList(),
      'jumperReports': _database.jumperReports.map((jumper, reports) {
        return MapEntry(idsRepo.idOf(jumper), reports.toJson());
      }),
      'jumperStats': _database.jumperStats.map((jumper, stats) {
        return MapEntry(idsRepo.idOf(jumper), stats.toJson());
      }),
      'teamReports': _database.teamReports.map((team, reports) {
        return MapEntry(idsRepo.idOf(team), reports.toJson());
      }),
    };
    await file.writeAsString(jsonEncode(json));
  }

  Future<void> _serializeItems<T>({
    required List<T> items,
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
      idsRepo: idsRepo,
    );
  }

  String _getFilePath({required Type type}) {
    if (type == MaleJumper) {
      return pathsRegistry.get<MaleJumper>();
    } else if (type == FemaleJumper) {
      return pathsRegistry.get<FemaleJumper>();
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
    'maleJumper': MaleJumper,
    'femaleJumper': FemaleJumper,
    'hill': Hill,
    'country': Country,
    'countryTeam': CountryTeam,
    'subteam': Subteam,
    'simulationSeason': SimulationSeason,
  };

  FutureOr<Json> Function(dynamic json) _appropriateSerializeFunction({
    required Type type,
  }) {
    if (type == MaleJumper) {
      return (item) => _serializeJumper(item);
    } else if (type == FemaleJumper) {
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

  Json _serializeJumper(Jumper item) {
    return item.toJson(countrySaver: const JsonCountryCodeSaver());
  }

  Json _serializeHill(Hill item) {
    return item.toJson(countrySaver: const JsonCountryCodeSaver());
  }

  Json _serializeCountry(Country item) {
    return item.toJson();
  }

  Json _serializeTeam(Team item) {
    return TeamSerializer(idsRepo: idsRepo).serialize(item);
  }

  Future<Json> _serializeSeason(SimulationSeason season) async {
    final standingsSerializer = StandingsSerializer(
        idsRepo: idsRepo,
        scoreSerializer: ScoreSerializer(idsRepo: idsRepo),
        positionsCreatorSerializer: StandingsPositionsCreatorSerializer());
    return await SimulationSeasonSerializer(
            idsRepo: idsRepo,
            eventSeriesSerializer: EventSeriesSerializer(
                idsRepo: idsRepo,
                calendarSerializer: EventSeriesCalendarSerializer(
                    idsRepo: idsRepo,
                    competitionSerializer: CompetitionSerializer(
                        idsRepo: idsRepo,
                        competitionRulesSerializer: CompetitionRulesProviderSerializer(
                            idsRepo: idsRepo,
                            rulesSerializer: DefaultCompetitionRulesSerializer(
                                idsRepo: idsRepo,
                                roundRulesSerializer: DefaultCompetitionRoundRulesSerializer(
                                    idsRepo: idsRepo,
                                    teamCompetitionGroupRulesSerializer:
                                        TeamCompetitionGroupRulesSerializer(
                                            idsRepo: idsRepo),
                                    entitiesLimitSerializer:
                                        EntitiesLimitSerializer(idsRepo: idsRepo),
                                    positionsCreatorSerializer:
                                        StandingsPositionsCreatorSerializer(),
                                    koRoundRulesSerializer: KoRoundRulesSerializer(
                                        idsRepo: idsRepo,
                                        advancementDeterminatorSerializer:
                                            KoRoundAdvancementDeterminatorSerializer(
                                                idsRepo: idsRepo,
                                                entitiesLimitSerializer: EntitiesLimitSerializer(
                                                    idsRepo: idsRepo)),
                                        koGroupsCreatorSerializer:
                                            KoGroupsCreatorSerializer(idsRepo: idsRepo)),
                                    windAveragerSerializer:
                                        WindAveragerSerializer(idsRepo: idsRepo),
                                    judgesCreatorSerializer:
                                        JudgesCreatorSerializer(idsRepo: idsRepo),
                                    jumpScoreCreatorSerializer: JumpScoreCreatorSerializer(idsRepo: idsRepo),
                                    competitionScoreCreatorSerializer: CompetitionScoreCreatorSerializer(idsRepo: idsRepo)))),
                        standingsSerializer: standingsSerializer),
                    classificationSerializer: ClassificationSerializer(idsRepo: idsRepo, standingsSerializer: standingsSerializer, defaultClassificationRulesSerializer: DefaultClassificationRulesSerializer(idsRepo: idsRepo, classificationScoreCreatorSerializer: ClassificationScoreCreatorSerializer(idsRepo: idsRepo)))),
                setupSerializer: EventSeriesSetupSerializer(idsRepo: idsRepo)))
        .serialize(season);
  }
}
