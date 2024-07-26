import 'package:sj_manager/models/db/event_series/competition/rules/entities_limit.dart';

abstract class CompetitionRoundRules<T> {
  const CompetitionRoundRules({
    required this.limit,
    required this.sortBeforeRound,
  });

  final EntitiesLimit limit;
  final bool sortBeforeRound;
}
