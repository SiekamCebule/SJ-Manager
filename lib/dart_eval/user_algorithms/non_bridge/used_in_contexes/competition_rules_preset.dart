import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_preset.dart';

class $CompetitionRulesPreset<T> implements CompetitionRulesPreset<T>, $Instance {
  $CompetitionRulesPreset.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'CompetitionRulesPreset',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType($type, generics: {
      'T': const BridgeGenericParam(),
    }),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'name'.param($String.$declaration.type.type.annotate),
          'rules'.param($CompetitionRules.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'name': BridgeFieldDef($String.$declaration.type.type.annotate),
      'rules': BridgeFieldDef($CompetitionRules.$declaration.type.type.annotate),
    },
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'competitionRules':
          BridgeFunctionDef(returns: $CompetitionRules.$declaration.type.type.annotate)
              .asMethod,
    },
    wrap: true,
  );

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $CompetitionRulesPreset.wrap(
      CompetitionRulesPreset(
        name: args[0]!.$value,
        rules: args[1]!.$value,
      ),
    );
  }

  @override
  final CompetitionRulesPreset<T> $value;

  @override
  CompetitionRulesPreset<T> get $reified => $value;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'props':
        return $List.wrap($value.props);
      case 'stringify':
        return $bool($value.stringify ?? false);
      case 'name':
        return $String($value.name);
      case 'rules':
        return $CompetitionRules.wrap($value.rules);
      case 'competitionRules':
        return $CompetitionRules.wrap($value.competitionRules);
      default:
        return null;
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => $value.props;

  @override
  String get name => $value.name;

  @override
  CompetitionRules<T> get competitionRules => $value.competitionRules;

  @override
  CompetitionRules<T> get rules => $value.rules;

  @override
  bool? get stringify => $value.stringify;
}
