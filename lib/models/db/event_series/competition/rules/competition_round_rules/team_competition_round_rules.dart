import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/db/team/team.dart';

class TeamCompetitionRoundRules extends CompetitionRoundRules<Team> {
  const TeamCompetitionRoundRules({
    required super.limit,
    required super.bibsAreReassigned,
    required super.gateCanChange,
    required super.gateCompensationCalculator,
    required super.windCompensationCalculator,
    required super.inrunLightsEnabled,
    required super.dsqEnabled,
    required super.positionsCreator,
    required super.canBeCancelledByWind,
    required super.ruleOf95HsFallEnabled,
    required super.judgesCount,
    required super.chooseSignificantJudges,
    required super.createJumpScore,
    required super.createCompetitionScore,
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
