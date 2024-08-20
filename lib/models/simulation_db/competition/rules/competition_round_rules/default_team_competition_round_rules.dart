import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class DefaultTeamCompetitionRoundRules extends DefaultCompetitionRoundRules<Team> {
  const DefaultTeamCompetitionRoundRules({
    required super.limit,
    required super.bibsAreReassigned,
    required super.gateCanChange,
    required super.windAverager,
    required super.inrunLightsEnabled,
    required super.dsqEnabled,
    required super.positionsCreator,
    required super.canBeCancelledByWind,
    required super.ruleOf95HsFallEnabled,
    required super.judgesCount,
    required super.competitionScoreCreator,
    required super.jumpScoreCreator,
    required super.significantJudgesChooser,
    required this.groups,
    required this.teamSize,
  });

  final List<TeamCompetitionGroupRules> groups;
  final int teamSize;

  int get groupsCount => groups.length;

  @override
  List<Object?> get props => [
        ...super.props,
        groups,
        teamSize,
      ];
}
