import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/hill/hill.dart';

class Competition<T> {
  const Competition({
    required this.hill,
    required this.date,
    required this.rules,
  });

  final Hill hill;
  final DateTime date;
  final CompetitionRules<T> rules;

  Competition<T> copyWith({
    Hill? hill,
    DateTime? date,
    CompetitionRules<T>? rules,
  }) {
    return Competition<T>(
      hill: hill ?? this.hill,
      date: date ?? this.date,
      rules: rules ?? this.rules,
    );
  }
}
