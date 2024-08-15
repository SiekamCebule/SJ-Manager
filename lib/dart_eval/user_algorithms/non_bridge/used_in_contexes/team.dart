import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/equatable_mixin.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/team_facts.dart';
import 'package:sj_manager/models/user_db/country/team_facts.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class $Team implements Team, $Instance {
  $Team.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'Team',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $with: [$EquatableMixin.$type],
      isAbstract: true,
    ),
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
    },
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'facts'.param($TeamFacts.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'facts': BridgeFieldDef($TeamFacts.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final Team $value;

  @override
  Team get $reified => $value;

  final $Instance _superclass;
  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'props':
        return $List.wrap($value.props);
      case 'stringify':
        return $bool($value.stringify ?? false);
      case 'facts':
        return $TeamFacts.wrap($value.facts);
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
  TeamFacts get facts => $value.facts;
}
