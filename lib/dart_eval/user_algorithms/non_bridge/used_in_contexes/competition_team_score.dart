import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition_jumper_score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/team.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class $CompetitionTeamScore<E extends Team>
    implements CompetitionTeamScore<E>, $Instance {
  $CompetitionTeamScore.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'CompetitionTeamScore',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $extends: $Score.$type,
      generics: {
        'E': BridgeGenericParam($extends: $Team.$declaration.type.type.annotate.type),
      },
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'entity'.param(const BridgeTypeRef.ref('E').annotate),
          'points'.param($double.$declaration.type.type.annotate),
          'entityScores'.param($List.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'entityScores':
          BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'components':
          BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
    },
    fields: {
      'entityScores':
          BridgeFieldDef($CompetitionJumperScore.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final CompetitionTeamScore $value;

  @override
  CompetitionTeamScore get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $CompetitionTeamScore.wrap(CompetitionTeamScore(
      entity: args[0]!.$value,
      points: args[1]!.$value,
      entityScores: args[2]!.$value,
    ));
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'entity':
        throw $Object($value.entity);
      case 'points':
        return $double($value.points);
      case 'entityScores':
        return $List.wrap($value.entityScores);
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
  List<SingleJumpScore<Jumper>> get jumpScores => $value.jumpScores;

  @override
  List<CompetitionJumperScore<Jumper>> get entityScores => $value.entityScores;
}
