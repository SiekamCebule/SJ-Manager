import 'package:equatable/equatable.dart';

import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';
import 'package:sj_manager/models/db/hill/hill.dart';

class Competition<E> with EquatableMixin {
  const Competition({
    required this.hill,
    required this.date,
    required this.rules,
    this.standings,
    this.labels = const {},
  });

  final Hill hill;
  final DateTime date;
  final CompetitionRules<E> rules;
  final StandingsRepo<E>? standings;
  final Set<Object> labels;

  Competition<E> copyWith({
    Hill? hill,
    DateTime? date,
    CompetitionRules<E>? rules,
    StandingsRepo<E>? standings,
    Set<Object>? labels,
  }) {
    return Competition<E>(
      hill: hill ?? this.hill,
      date: date ?? this.date,
      rules: rules ?? this.rules,
      standings: standings ?? this.standings,
      labels: labels ?? this.labels,
    );
  }

  @override
  List<Object?> get props => [hill, date, rules];
}
