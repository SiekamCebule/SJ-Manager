import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';

abstract interface class DefaultCompetitionRulesProvider<T> {
  const DefaultCompetitionRulesProvider();
  DefaultCompetitionRules<T> get competitionRules;
}
