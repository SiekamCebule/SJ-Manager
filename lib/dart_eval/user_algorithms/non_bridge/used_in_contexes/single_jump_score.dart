import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';

class $SingleJumpScore<E> implements SingleJumpScore<E>, $Instance {
  $SingleJumpScore.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'SingleJumpScore',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $extends: $Score.$type,
      generics: {
        'E': const BridgeGenericParam(),
      },
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'entity'.param(const BridgeTypeRef.ref('E').annotate),
          'distancePoints'.param($double.$declaration.type.type.annotate),
          'judgesPoints'.param($double.$declaration.type.type.annotate),
          'gatePoints'.param($double.$declaration.type.type.annotate),
          'windPoints'.param($double.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'points':
          BridgeFunctionDef(returns: $double.$declaration.type.type.annotate).asMethod,
      'components':
          BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'totalCompensation':
          BridgeFunctionDef(returns: $double.$declaration.type.type.annotate).asMethod,
    },
    fields: {
      'distancePoints': BridgeFieldDef($double.$declaration.type.type.annotate),
      'judgesPoints': BridgeFieldDef($double.$declaration.type.type.annotate),
      'gatePoints': BridgeFieldDef($double.$declaration.type.type.annotate),
      'windPoints': BridgeFieldDef($double.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final SingleJumpScore $value;

  @override
  SingleJumpScore get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $SingleJumpScore.wrap(
      SingleJumpScore(
        entity: args[0]!.$value,
        distancePoints: args[1]!.$value,
        judgesPoints: args[2]!.$value,
        gatePoints: args[3]!.$value,
        windPoints: args[4]!.$value,
      ),
    );
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'entity':
        throw $Object($value.entity);
      case 'distancePoints':
        return $double($value.distancePoints);
      case 'judgesPoints':
        return $double($value.judgesPoints);
      case 'gatePoints':
        return $double($value.gatePoints);
      case 'windPoints':
        return $double($value.windPoints);
      case 'totalCompensation':
        return $double($value.totalCompensation);
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
  double get distancePoints => $value.distancePoints;

  @override
  double get judgesPoints => $value.judgesPoints;

  @override
  double get gatePoints => $value.gatePoints;

  @override
  double get windPoints => $value.windPoints;

  @override
  double get totalCompensation => $value.totalCompensation;
}
