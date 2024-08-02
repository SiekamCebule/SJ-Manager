import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_provider.dart';

class CompetitionRulesPreset<T>
    with EquatableMixin
    implements CompetitionRulesProvider<T> {
  const CompetitionRulesPreset({
    required this.name,
    required this.rules,
  });

  final String name;
  final CompetitionRules<T> rules;

  @override
  CompetitionRules<T> get competitionRules => rules;

  @override
  List<Object?> get props => [
        name,
        rules,
      ];
}
