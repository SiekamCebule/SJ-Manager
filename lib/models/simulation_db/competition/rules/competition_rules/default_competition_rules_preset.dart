import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_provider.dart';

class DefaultCompetitionRulesPreset<T>
    with EquatableMixin
    implements DefaultCompetitionRulesProvider<T> {
  const DefaultCompetitionRulesPreset({
    required this.name,
    required this.rules,
  });

  const DefaultCompetitionRulesPreset.empty()
      : this(name: '', rules: const DefaultCompetitionRules.empty());

  final String name;
  final DefaultCompetitionRules<T> rules;

  @override
  DefaultCompetitionRules<T> get competitionRules => rules;

  @override
  List<Object?> get props => [
        name,
        rules,
      ];
}
