import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_provider.dart';

class CompetitionRules<T> with EquatableMixin implements CompetitionRulesProvider<T> {
  const CompetitionRules({
    required this.rounds,
  });

  const CompetitionRules.empty()
      : this(
          rounds: const [],
        );

  final List<CompetitionRoundRules<T>> rounds;

  int get roundsCount => rounds.length;

  @override
  CompetitionRules<T> get competitionRules => this;

  @override
  List<Object?> get props => [rounds];
}
