import 'package:sj_manager/bloc/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class CompetitionRoundRulesSerializer
    implements SimulationDbPartSerializer<CompetitionRoundRules> {
  const CompetitionRoundRulesSerializer({
    required this.idsRepo,
    required this.teamCompetitionGroupRulesSerializer,
    required this.entitiesLimitSerializer,
    required this.positionsCreatorSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<EntitiesLimit> entitiesLimitSerializer;
  final SimulationDbPartSerializer<TeamCompetitionGroupRules>
      teamCompetitionGroupRulesSerializer;
  final SimulationDbPartSerializer<StandingsPositionsCreator> positionsCreatorSerializer;

  @override
  Json serialize(CompetitionRoundRules rules) {
    return _serializeAppropriate(rules);
  }

  Json _serializeAppropriate(CompetitionRoundRules rules) {
    if (rules is IndividualCompetitionRoundRules) {
      return _serializeIndividual(rules);
    } else if (rules is TeamCompetitionRoundRules) {
      return _serializeTeam(rules);
    } else {
      throw UnsupportedError(
          'Unsupported CompetitionRoundRules type: ${rules.runtimeType}');
    }
  }

  Json _serializeIndividual(IndividualCompetitionRoundRules rules) {
    return {
      'bibsAreReassigned': rules.bibsAreReassigned,
      if (rules.limit != null) 'limit': entitiesLimitSerializer.serialize(rules.limit!),
      if (rules.limit == null) 'limit': null,
      'gateCanChange': rules.gateCanChange,
      'windAveragerId': idsRepo.idOf(rules.windAverager),
      'inrunLightsEnabled': rules.inrunLightsEnabled,
      'dsqEnabled': rules.dsqEnabled,
      'positionsCreator': positionsCreatorSerializer.serialize(rules.positionsCreator),
      'canBeCancelledByWind': rules.canBeCancelledByWind,
      'ruleOf95HsFallEnabled': rules.ruleOf95HsFallEnabled,
      'judgesCount': rules.judgesCount,
      'competitionScoreCreatorId': idsRepo.idOf(rules.competitionScoreCreator),
      'jumpScoreCreatorId': idsRepo.idOf(rules.jumpScoreCreator),
      'significantJudgesChooserId': idsRepo.idOf(rules.significantJudgesChooser),
    };
  }

  Json _serializeTeam(TeamCompetitionRoundRules rules) {
    final groupsJson = rules.groups.map((rules) {
      return teamCompetitionGroupRulesSerializer.serialize(rules);
    });
    return {
      'bibsAreReassigned': rules.bibsAreReassigned,
      if (rules.limit != null) 'limit': entitiesLimitSerializer.serialize(rules.limit!),
      if (rules.limit == null) 'limit': null,
      'gateCanChange': rules.gateCanChange,
      'windAveragerId': idsRepo.idOf(rules.windAverager),
      'inrunLightsEnabled': rules.inrunLightsEnabled,
      'dsqEnabled': rules.dsqEnabled,
      'positionsCreator': positionsCreatorSerializer.serialize(rules.positionsCreator),
      'canBeCancelledByWind': rules.canBeCancelledByWind,
      'ruleOf95HsFallEnabled': rules.ruleOf95HsFallEnabled,
      'judgesCount': rules.judgesCount,
      'competitionScoreCreatorId': idsRepo.idOf(rules.competitionScoreCreator),
      'jumpScoreCreatorId': idsRepo.idOf(rules.jumpScoreCreator),
      'significantJudgesChooserId': idsRepo.idOf(rules.significantJudgesChooser),
      'groups': groupsJson,
      'teamSize': rules.teamSize,
    };
  }
}
