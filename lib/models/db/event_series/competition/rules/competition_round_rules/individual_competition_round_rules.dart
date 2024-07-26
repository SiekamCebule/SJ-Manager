import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';

class IndividualCompetitionRoundRules extends CompetitionRoundRules<Jumper> {
  const IndividualCompetitionRoundRules({
    required super.limit,
    required super.sortBeforeRound,
  });
}
