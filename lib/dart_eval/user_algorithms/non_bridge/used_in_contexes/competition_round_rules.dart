import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/has_points_mixin.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_round_rules/individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/competition_rules/competition_rules.dart';

/*class $IndividualCompetitionRoundRules<E>
    implements IndividualCompetitionRoundRules<E>, $Instance {
  $IndividualCompetitionRoundRules.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'IndividualCompetitionRoundRules',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      // TODO: extends, but we're omitting it
      $with: [$HasPointsMixin.$type],
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'limit'.param($EntitiesLimit.$declaration.type.type.annotate(nullable: true)),
          'bibsAreReassigned'.param($bool.$declaration.type.type.annotate),
          'gateCanChange'.param($bool.$declaration.type.type.annotate),
          'windAverager'
              .param($WindAverager.$declaration.type.type.annotate(nullable: true)),
          'inrunLightsEnabled'.param($bool.$declaration.type.type.annotate),
          'dsqEnabled'.param($bool.$declaration.type.type.annotate),
          'canBeCancelledByWind'.param($bool.$declaration.type.type.annotate),
          'ruleOf95HsFallEnabled'.param($bool.$declaration.type.type.annotate),
          'judgesCount'.param($int.$declaration.type.type.annotate),
          'significantJudgesChooser'
              .param($SignificantJudgesChooser.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
    },
    fields: {
      'limit':
          BridgeFieldDef($EntitiesLimit.$declaration.type.type.annotate(nullable: true)),
      'bibsAreReassigned': BridgeFieldDef($bool.$declaration.type.type.annotate),
      'gateCanChange': BridgeFieldDef($bool.$declaration.type.type.annotate),
      'inrunLightsEnabled': BridgeFieldDef($bool.$declaration.type.type.annotate),
      'dsqEnabled': BridgeFieldDef($bool.$declaration.type.type.annotate),
      'canBeCancelledByWind': BridgeFieldDef($bool.$declaration.type.type.annotate),
      'ruleOf95HsFallEnabled': BridgeFieldDef($bool.$declaration.type.type.annotate),
      'judgesCount': BridgeFieldDef($int.$declaration.type.type.annotate),
    },
    // TODO: OMITTED THE CREATORS
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
        return $List.wrap($value.rounds);
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
*/