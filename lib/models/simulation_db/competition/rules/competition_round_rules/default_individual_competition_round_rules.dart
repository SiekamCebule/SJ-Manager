import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_team_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/score/typedefs.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class DefaultIndividualCompetitionRoundRules
    extends DefaultCompetitionRoundRules<Jumper> {
  const DefaultIndividualCompetitionRoundRules({
    required super.limit,
    required super.bibsAreReassigned,
    required super.startlistIsSorted,
    required super.gateCanChange,
    required super.gateCompensationsEnabled,
    required super.windCompensationsEnabled,
    required super.windAverager,
    required super.inrunLightsEnabled,
    required super.dsqEnabled,
    required super.positionsCreator,
    required super.ruleOf95HsFallEnabled,
    required super.judgesCount,
    required super.judgesCreator,
    required super.significantJudgesCount,
    required super.competitionScoreCreator,
    required super.jumpScoreCreator,
    required super.koRules,
  });

  DefaultTeamCompetitionRoundRules toTeam({
    required CompetitionScoreCreator<CompetitionTeamScore> competitionScoreCreator,
    required List<TeamCompetitionGroupRules> groups,
  }) {
    return DefaultTeamCompetitionRoundRules(
      limit: limit,
      bibsAreReassigned: bibsAreReassigned,
      startlistIsSorted: startlistIsSorted,
      gateCanChange: gateCanChange,
      gateCompensationsEnabled: gateCompensationsEnabled,
      windCompensationsEnabled: windCompensationsEnabled,
      windAverager: windAverager,
      inrunLightsEnabled: inrunLightsEnabled,
      dsqEnabled: dsqEnabled,
      positionsCreator: positionsCreator,
      ruleOf95HsFallEnabled: ruleOf95HsFallEnabled,
      judgesCount: judgesCount,
      judgesCreator: judgesCreator,
      significantJudgesCount: significantJudgesCount,
      competitionScoreCreator: competitionScoreCreator,
      jumpScoreCreator: jumpScoreCreator,
      koRules: koRules,
      groups: groups,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
      ];
}
