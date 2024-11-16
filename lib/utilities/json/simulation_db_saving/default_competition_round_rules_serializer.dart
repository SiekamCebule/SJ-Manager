import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/entities_limit.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/ko/ko_round_rules.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/judges_creator/judges_creator.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/utils/wind_averager/wind_averager.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class DefaultCompetitionRoundRulesSerializer
    implements SimulationDbPartSerializer<DefaultCompetitionRoundRules> {
  const DefaultCompetitionRoundRulesSerializer({
    required this.idsRepo,
    required this.teamCompetitionGroupRulesSerializer,
    required this.entitiesLimitSerializer,
    required this.positionsCreatorSerializer,
    required this.koRoundRulesSerializer,
    required this.windAveragerSerializer,
    required this.judgesCreatorSerializer,
    required this.jumpScoreCreatorSerializer,
    required this.competitionScoreCreatorSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<EntitiesLimit> entitiesLimitSerializer;
  final SimulationDbPartSerializer<TeamCompetitionGroupRules>
      teamCompetitionGroupRulesSerializer;
  final SimulationDbPartSerializer<KoRoundRules> koRoundRulesSerializer;
  final StandingsPositionsCreatorSerializer positionsCreatorSerializer;

  final SimulationDbPartSerializer<WindAverager> windAveragerSerializer;
  final SimulationDbPartSerializer<JudgesCreator> judgesCreatorSerializer;
  final SimulationDbPartSerializer<JumpScoreCreator> jumpScoreCreatorSerializer;
  final SimulationDbPartSerializer<CompetitionScoreCreator>
      competitionScoreCreatorSerializer;

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
      'startlistIsSorted': rules.startlistIsSorted,
      'limit':
          rules.limit != null ? entitiesLimitSerializer.serialize(rules.limit!) : null,
      'gateCanChange': rules.gateCanChange,
      'gateCompensationsEnabled': rules.gateCompensationsEnabled,
      'windCompensationsEnabled': rules.windCompensationsEnabled,
      'windAverager': rules.windAverager != null
          ? windAveragerSerializer.serialize(rules.windAverager!)
          : null,
      'inrunLightsEnabled': rules.inrunLightsEnabled,
      'dsqEnabled': rules.dsqEnabled,
      'positionsCreator': positionsCreatorSerializer.serialize(rules.positionsCreator),
      'ruleOf95HsFallEnabled': rules.ruleOf95HsFallEnabled,
      'judgesCount': rules.judgesCount,
      'judgesCreator': judgesCreatorSerializer.serialize(rules.judgesCreator),
      'significantJudgesCount': rules.significantJudgesCount,
      'competitionScoreCreator': competitionScoreCreatorSerializer.serialize(
        rules.competitionScoreCreator as CompetitionScoreCreator,
      ),
      'jumpScoreCreator': jumpScoreCreatorSerializer.serialize(rules.jumpScoreCreator),
      'koRoundRules':
          rules.koRules != null ? koRoundRulesSerializer.serialize(rules.koRules!) : null,
    };
  }

  Json _serializeTeam(DefaultTeamCompetitionRoundRules rules) {
    final groupsJson = rules.groups.map((rules) {
      return teamCompetitionGroupRulesSerializer.serialize(rules);
    }).toList();
    return {
      'type': 'team',
      'bibsAreReassigned': rules.bibsAreReassigned,
      'startlistIsSorted': rules.startlistIsSorted,
      'limit':
          rules.limit != null ? entitiesLimitSerializer.serialize(rules.limit!) : null,
      'gateCanChange': rules.gateCanChange,
      'gateCompensationsEnabled': rules.gateCompensationsEnabled,
      'windCompensationsEnabled': rules.windCompensationsEnabled,
      'windAverager': rules.windAverager != null
          ? windAveragerSerializer.serialize(rules.windAverager!)
          : null,
      'inrunLightsEnabled': rules.inrunLightsEnabled,
      'dsqEnabled': rules.dsqEnabled,
      'positionsCreator': positionsCreatorSerializer.serialize(rules.positionsCreator),
      'ruleOf95HsFallEnabled': rules.ruleOf95HsFallEnabled,
      'judgesCount': rules.judgesCount,
      'judgesCreator': judgesCreatorSerializer.serialize(rules.judgesCreator),
      'significantJudgesCount': rules.significantJudgesCount,
      'competitionScoreCreator': competitionScoreCreatorSerializer.serialize(
        rules.competitionScoreCreator as CompetitionScoreCreator,
      ),
      'jumpScoreCreator': jumpScoreCreatorSerializer.serialize(rules.jumpScoreCreator),
      'groups': groupsJson,
      'koRoundRules':
          rules.koRules != null ? koRoundRulesSerializer.serialize(rules.koRules!) : null,
    };
  }
}
