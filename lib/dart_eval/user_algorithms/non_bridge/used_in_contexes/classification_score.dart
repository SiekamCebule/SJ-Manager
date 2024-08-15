import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/has_points_mixin.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/classification_score.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';

class $ClassificationScore<E> implements ClassificationScore<E>, $Instance {
  $ClassificationScore.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'ClassificationScore',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      generics: {
        'E': const BridgeGenericParam(),
      },
      $extends: $Score.$type,
      $with: [$HasPointsMixin.$type],
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'entity'.param(const BridgeTypeRef.ref('E').annotate),
          'points'.param($double.$declaration.type.type.annotate),
          'competitionScores'.param($List.$declaration.type.type.annotate),
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
    },
    methods: {
      'operator>':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'operator<':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'compareTo': BridgeFunctionDef(
        returns: $int.$declaration.type.type.annotate,
        params: [
          BridgeParameter('', $Object.$declaration.type.type.annotate, false),
        ],
      ).asMethod,
    },
    fields: {
      'entity': BridgeFieldDef(const BridgeTypeRef.ref('E').annotate),
      'points': BridgeFieldDef($double.$declaration.type.type.annotate),
      'competitionScores': BridgeFieldDef($List.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final ClassificationScore $value;

  @override
  ClassificationScore get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $ClassificationScore.wrap(
      ClassificationScore(
        entity: args[0]!.$value,
        points: args[1]!.$value,
        competitionScores: args[2]!.$value,
      ),
    );
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'entity':
        return $Object($value.entity);
      case 'points':
        return $double($value.points);
      case 'competitionScores':
        return $List.wrap($value.competitionScores);
      case 'props':
        return $List.wrap($value.props);
      case 'stringify':
        return $bool($value.stringify ?? false);
      case 'components':
        return $List.wrap($value.components);
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
  List<CompetitionScore> get competitionScores => $value.competitionScores;
}
