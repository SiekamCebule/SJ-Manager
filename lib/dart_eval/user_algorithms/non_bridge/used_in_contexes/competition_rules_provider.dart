import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules_provider.dart';

class $CompetitionRulesProvider<E> implements CompetitionRulesProvider<E>, $Instance {
  $CompetitionRulesProvider.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'CompetitionRulesProvider',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      isAbstract: true,
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
      ).asConstructor
    },
    getters: {
      'competitionRules':
          BridgeFunctionDef(returns: $CompetitionRules.$type.annotate).asMethod,
    },
    wrap: true,
  );

  @override
  final CompetitionRulesProvider $value;

  @override
  CompetitionRulesProvider get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'competitionRules':
        return $CompetitionRules.wrap($value.competitionRules);
      default:
        return _superclass.$getProperty(runtime, identifier);
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }

  @override
  CompetitionRules<E> get competitionRules =>
      $value.competitionRules as CompetitionRules<E>;
}
