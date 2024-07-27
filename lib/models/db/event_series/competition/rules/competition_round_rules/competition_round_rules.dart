import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/entities_limit.dart';

abstract class CompetitionRoundRules<T> with EquatableMixin {
  const CompetitionRoundRules({
    required this.limit,
  });

  final EntitiesLimit? limit;

  @override
  List<Object?> get props => [limit];
}
