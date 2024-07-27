import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_round_rules/competition_round_rules.dart';

abstract class CompetitionRules<T> with EquatableMixin {
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

  @override
  // TODO: implement props
  List<Object?> get props => [rounds, allowChangingGates];
}
