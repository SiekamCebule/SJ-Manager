import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_rules_provider.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';

class $CompetitionRules<E> implements CompetitionRules<E>, $Instance {
  $CompetitionRules.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'CompetitionRules',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $with: [$HasPointsMixin.$type],
      $implements: [$CompetitionRulesProvider.$type],
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'rounds'.param($List.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'competitionRules': BridgeFunctionDef(returns: $type.annotate).asMethod,
      'roundsCount':
          BridgeFunctionDef(returns: $int.$declaration.type.type.annotate).asMethod,
    },
    fields: {
      'rounds': BridgeFieldDef($List.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final CompetitionRules $value;

  @override
  CompetitionRules get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $CompetitionRules.wrap(
      CompetitionRules(rounds: args[0]!.$value),
    );
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'rounds':
        throw UnimplementedError();
      case 'competitionRules':
        return $CompetitionRules.wrap($value.competitionRules);
      case 'roundsCount':
        return $int($value.roundsCount);
      case 'props':
        return $List.wrap($value.props);
      case 'stringify':
        return $bool($value.stringify ?? false);
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
  List<Object?> get props => $value.props;

  @override
  bool? get stringify => $value.stringify;

  @override
  List<CompetitionRoundRules<E>> get rounds => $value.rounds.cast();

  @override
  CompetitionRules<E> get competitionRules =>
      $value.competitionRules as CompetitionRules<E>;

  @override
  int get roundsCount => $value.roundsCount;
}
