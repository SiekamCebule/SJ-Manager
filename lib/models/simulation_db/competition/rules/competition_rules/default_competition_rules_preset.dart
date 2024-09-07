import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/default_competition_rules_provider.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

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
  Type get entityType {
    if (rules is DefaultCompetitionRules<Jumper>) {
      return Jumper;
    } else if (rules is DefaultCompetitionRules<Team>) {
      return Team;
    } else {
      throw TypeError();
    }
  }

  @override
  DefaultCompetitionRules<T> get competitionRules => rules;

  @override
  List<Object?> get props => [
        name,
        rules,
      ];
}
