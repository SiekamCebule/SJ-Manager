import 'package:equatable/equatable.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_competition_round_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_provider.dart';

class DefaultCompetitionRules<T>
    with EquatableMixin
    implements DefaultCompetitionRulesProvider<T> {
  const DefaultCompetitionRules({
    required this.rounds,
  });

  const DefaultCompetitionRules.empty()
      : this(
          rounds: const [],
        );

  final List<DefaultCompetitionRoundRules<T>> rounds;

  DefaultCompetitionRules<T> copyWith({
    List<DefaultCompetitionRoundRules<T>>? rounds,
  }) {
    return DefaultCompetitionRules<T>(
      rounds: rounds ?? this.rounds,
    );
  }

  int get roundsCount => rounds.length;

  @override
  DefaultCompetitionRules<T> get competitionRules => this;

  @override
  List<Object?> get props => [
        rounds,
      ];
}
