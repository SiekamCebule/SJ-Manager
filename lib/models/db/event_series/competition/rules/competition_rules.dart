import 'package:sj_manager/models/db/event_series/competition/rules/entities_limit.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';

abstract class CompetitionRules<T> {
  const CompetitionRules({
    required this.rounds,
    required this.allowChangingGates,
  });

  final List<CompetitionRoundRules<T>> rounds;
  final bool allowChangingGates;

  // TODO: WindCompensationsDelegate
  // TODO: GateCompensationsDelegate
  // TODO: Add other rules

  int get roundsCount => rounds.length;
}

abstract class CompetitionRoundRules<T> {
  const CompetitionRoundRules({
    required this.limit,
    required this.sortBeforeRound,
  });

  final EntitiesLimit limit;
  final bool sortBeforeRound;
}

class IndividualCompetitionRoundRules extends CompetitionRoundRules<Jumper> {
  const IndividualCompetitionRoundRules({
    required super.limit,
    required super.sortBeforeRound,
  });
}
