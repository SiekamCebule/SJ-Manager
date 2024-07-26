// TODO: Co z KO?

import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/team/team.dart';

class TeamCompetitionRules extends CompetitionRules<Team> {
  const TeamCompetitionRules({
    required super.rounds,
    required super.allowChangingGates,
  });
}
