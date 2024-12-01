import 'package:equatable/equatable.dart';

import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules_provider.dart';

class Competition<E> with EquatableMixin {
  const Competition({
    required this.hill,
    required this.date,
    required this.rules,
    this.standings,
    this.labels = const [],
  });

  final Hill hill;
  final DateTime date;
  final DefaultCompetitionRulesProvider<E> rules;
  final Standings? standings;
  final List<Object> labels;

  @override
  List<Object?> get props => [
        hill,
        date,
        rules,
        standings,
        labels,
      ];

  Competition<E> copyWith({
    Hill? hill,
    DateTime? date,
    DefaultCompetitionRulesProvider<E>? rules,
    Standings? standings,
    List<Object>? labels,
  }) {
    return Competition<E>(
      hill: hill ?? this.hill,
      date: date ?? this.date,
      rules: rules ?? this.rules,
      standings: standings ?? this.standings,
      labels: labels ?? this.labels,
    );
  }
}
