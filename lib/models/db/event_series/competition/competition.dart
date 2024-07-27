// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:sj_manager/models/db/event_series/competition/competition_type.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/db/hill/hill.dart';

class Competition<T> with EquatableMixin {
  const Competition({
    required this.hill,
    required this.date,
    required this.rules,
    required this.type,
  });

  final Hill hill;
  final DateTime date;
  final CompetitionRules<T> rules;
  final CompetitionType type;

  Competition<T> copyWith({
    Hill? hill,
    DateTime? date,
    CompetitionRules<T>? rules,
    CompetitionType? type,
  }) {
    return Competition<T>(
      hill: hill ?? this.hill,
      date: date ?? this.date,
      rules: rules ?? this.rules,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [hill, date, rules, type];
}
