import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/jumper.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class $CompetitionJumperScore<E extends Jumper>
    implements CompetitionJumperScore<E>, $Instance {
  $CompetitionJumperScore.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'CompetitionJumperScore',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $extends: $Score.$type,
      generics: {
        'E': BridgeGenericParam($extends: $Jumper.$declaration.type.type.annotate.type),
      },
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'entity'.param(const BridgeTypeRef.ref('E').annotate),
          'points'.param($double.$declaration.type.type.annotate),
          'jumpScores'.param($List.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'jumpScores':
          BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'components':
          BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'points':
          BridgeFunctionDef(returns: $double.$declaration.type.type.annotate).asMethod,
    },
    fields: {},
    wrap: true,
  );

  @override
  final CompetitionJumperScore $value;

  @override
  CompetitionJumperScore get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $CompetitionJumperScore.wrap(CompetitionJumperScore(
      entity: args[0]!.$value,
      points: args[1]!.$value,
      jumpScores: args[2]!.$value,
    ));
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'entity':
        throw $Object($value.entity);
      case 'points':
        return $double($value.points);
      case 'jumpScores':
        return $List.wrap($value.jumpScores);
      case 'components':
        return $List.wrap($value.components);
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
  E get entity => $value.entity as E;

  @override
  double get points => $value.points;

  @override
  List<double> get components => $value.components;

  @override
  int compareTo(other) {
    return $value.compareTo(other);
  }

  @override
  List<Object?> get props => $value.props;

  @override
  bool? get stringify => $value.stringify;

  @override
  bool operator >(other) {
    return $value > other;
  }

  @override
  bool operator <(other) {
    return $value < other;
  }

  @override
  List<SingleJumpScore> get jumpScores => $value.jumpScores;
}
