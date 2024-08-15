import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';

abstract interface class CompetitionRulesProvider<T> {
  const CompetitionRulesProvider();
  CompetitionRules<T> get competitionRules;
}
