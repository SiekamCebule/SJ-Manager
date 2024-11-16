import 'package:equatable/equatable.dart';

import 'package:sj_manager/data/models/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/data/models/simulation/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/data/models/simulation/standings/score/details/score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/standings.dart';
import 'package:sj_manager/data/models/database/hill/hill.dart';

class Competition<E, S extends Standings<dynamic, ScoreDetails>> with EquatableMixin {
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
  final S? standings;
  final List<Object> labels;

  Competition<E, S> copyWith({
    Hill? hill,
    DateTime? date,
    DefaultCompetitionRules<E>? rules,
    S? standings,
    List<Object>? labels,
  }) {
    return Competition<E, S>(
      hill: hill ?? this.hill,
      date: date ?? this.date,
      rules: rules ?? this.rules,
      standings: standings ?? this.standings,
      labels: labels ?? this.labels,
    );
  }

  @override
  List<Object?> get props => [
        hill,
        date,
        rules,
        standings,
        labels,
      ];
}
