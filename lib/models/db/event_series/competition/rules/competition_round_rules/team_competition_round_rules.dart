import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/group_rules/team_competition_group_rules.dart';
import 'package:sj_manager/models/db/team/team.dart';

class TeamCompetitionRoundRules extends CompetitionRoundRules<Team> {
  const TeamCompetitionRoundRules({
    required super.limit,
    required this.groups,
  });

  final List<TeamCompetitionGroupRules> groups;

  int get groupsCount => groups.length;
}
