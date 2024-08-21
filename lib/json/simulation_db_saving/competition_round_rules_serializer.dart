import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class CompetitionRoundRulesSerializer
    implements SimulationDbPartSerializer<DefaultCompetitionRoundRules> {
  const CompetitionRoundRulesSerializer({
    required this.idsRepo,
    required this.teamCompetitionGroupRulesSerializer,
    required this.entitiesLimitSerializer,
    required this.positionsCreatorSerializer,
    required this.koRoundRulesSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<EntitiesLimit> entitiesLimitSerializer;
  final SimulationDbPartSerializer<TeamCompetitionGroupRules>
      teamCompetitionGroupRulesSerializer;
  final SimulationDbPartSerializer<KoRoundRules> koRoundRulesSerializer;
  final StandingsPositionsCreatorSerializer positionsCreatorSerializer;

  @override
  Json serialize(DefaultCompetitionRoundRules rules) {
    return _serializeAppropriate(rules);
  }

  Json _serializeAppropriate(DefaultCompetitionRoundRules rules) {
    if (rules is DefaultIndividualCompetitionRoundRules) {
      return _serializeIndividual(rules);
    } else if (rules is DefaultTeamCompetitionRoundRules) {
      return _serializeTeam(rules);
    } else {
      throw UnsupportedError(
          'Unsupported CompetitionRoundRules type: ${rules.runtimeType}');
    }
  }

  Json _serializeIndividual(DefaultIndividualCompetitionRoundRules rules) {
    return {
      'type': 'individual',
      'bibsAreReassigned': rules.bibsAreReassigned,
      'limit':
          rules.limit != null ? entitiesLimitSerializer.serialize(rules.limit!) : null,
      'gateCanChange': rules.gateCanChange,
      'windAveragerId': idsRepo.idOf(rules.windAverager),
      'inrunLightsEnabled': rules.inrunLightsEnabled,
      'dsqEnabled': rules.dsqEnabled,
      'positionsCreator': positionsCreatorSerializer.serialize(rules.positionsCreator),
      'ruleOf95HsFallEnabled': rules.ruleOf95HsFallEnabled,
      'judgesCount': rules.judgesCount,
      'significantJudgesCount': rules.significantJudgesCount,
      'competitionScoreCreatorId': idsRepo.idOf(rules.competitionScoreCreator),
      'jumpScoreCreatorId': idsRepo.idOf(rules.jumpScoreCreator),
      'koRoundRules':
          rules.koRules != null ? koRoundRulesSerializer.serialize(rules.koRules!) : null,
    };
  }

  Json _serializeTeam(DefaultTeamCompetitionRoundRules rules) {
    final groupsJson = rules.groups.map((rules) {
      return teamCompetitionGroupRulesSerializer.serialize(rules);
    });
    return {
      'type': 'team',
      'bibsAreReassigned': rules.bibsAreReassigned,
      'limit':
          rules.limit != null ? entitiesLimitSerializer.serialize(rules.limit!) : null,
      'gateCanChange': rules.gateCanChange,
      'windAveragerId': idsRepo.idOf(rules.windAverager),
      'inrunLightsEnabled': rules.inrunLightsEnabled,
      'dsqEnabled': rules.dsqEnabled,
      'positionsCreator': positionsCreatorSerializer.serialize(rules.positionsCreator),
      'ruleOf95HsFallEnabled': rules.ruleOf95HsFallEnabled,
      'judgesCount': rules.judgesCount,
      'significantJudgesCount': rules.significantJudgesCount,
      'competitionScoreCreatorId': idsRepo.idOf(rules.competitionScoreCreator),
      'jumpScoreCreatorId': idsRepo.idOf(rules.jumpScoreCreator),
      'groups': groupsJson,
      'teamSize': rules.teamSize,
      'koRoundRules':
          rules.koRules != null ? koRoundRulesSerializer.serialize(rules.koRules!) : null,
    };
  }
}
