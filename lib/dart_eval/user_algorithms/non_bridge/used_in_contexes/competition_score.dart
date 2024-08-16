import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/single_jump_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class $CompetitionScore<E extends Jumper> implements CompetitionScore<E>, $Instance {
  $CompetitionScore.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'CompetitionScore',
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
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'jumpScores': BridgeFunctionDef(
              returns: BridgeTypeRef(
        CoreTypes.list,
        [
          BridgeTypeRef(
            $SingleJumpScore.$declaration.type.type.spec,
            [const BridgeTypeRef.ref('E')],
          ),
        ],
      ).annotate)
          .asMethod,
      'components': BridgeFunctionDef(
              returns: const BridgeTypeRef(CoreTypes.list, [
        BridgeTypeRef(
          CoreTypes.double,
        )
      ]).annotate)
          .asMethod,
      'points':
          BridgeFunctionDef(returns: $double.$declaration.type.type.annotate).asMethod,
    },
    fields: {
      'entity': BridgeFieldDef(const BridgeTypeRef.ref('T').annotate),
    },
    wrap: true,
  );

  @override
  final CompetitionScore<E> $value;

  @override
  CompetitionScore<E> get $reified => $value;

  final $Instance _superclass;

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
  E get entity => $value.entity;

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
  List<SingleJumpScore<E>> get jumpScores => $value.jumpScores.cast();
}
