import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/individual_competition_round_rules.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';

class IndividualCompetitionRules extends CompetitionRules<Jumper> {
  const IndividualCompetitionRules({
    required super.rounds,
    required super.allowChangingGates,
  });
}

class IndQualsRules extends IndividualCompetitionRules {
  IndQualsRules()
      : super(allowChangingGates: false, rounds: [
          const IndividualCompetitionRoundRules(limit: null, sortBeforeRound: false)
        ]);
}
