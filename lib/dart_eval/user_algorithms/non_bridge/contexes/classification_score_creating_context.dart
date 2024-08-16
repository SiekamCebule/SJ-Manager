import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/contexes/entity_related_algorithm_context.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/classification_score.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/competition.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/country_team.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/jumper.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/team.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/classification_score.dart';
import 'package:sj_manager/models/user_algorithms/concrete/classification_score_creator.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class $ClassificationScoreCreatingContext<E>
    implements ClassificationScoreCreatingContext<E>, $Instance {
  $ClassificationScoreCreatingContext.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'ClassificationScoreCreatingContext',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      generics: {
        'E': const BridgeGenericParam(),
      },
      $extends: BridgeTypeRef($EntityRelatedAlgorithmContext.$type.spec,
          [const BridgeTypeRef.ref('E')]), // What with the E generic type?
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'entity'.param(const BridgeTypeRef.ref('E').annotate),
          'playedCompetitions'.param(BridgeTypeRef(
            CoreTypes.list,
            [BridgeTypeRef($Competition.$declaration.type.type.spec)],
          ).annotate),
          'classificationScore'.param(BridgeTypeRef(
            CoreTypes.list,
            [BridgeTypeRef($ClassificationScore.$declaration.type.type.spec)],
          ).annotate),
        ],
      ).asConstructor
    },
    fields: {
      'entity': BridgeFieldDef(const BridgeTypeRef.ref('E').annotate),
      'playedCompetitions': BridgeFieldDef(BridgeTypeRef(
        CoreTypes.list,
        [BridgeTypeRef($Competition.$declaration.type.type.spec)],
      ).annotate),
      //'eventSeries': BridgeFieldDef(),
      'classificationScore': BridgeFieldDef(BridgeTypeRef(
        CoreTypes.list,
        [BridgeTypeRef($ClassificationScore.$declaration.type.type.spec)],
      ).annotate),
    },
    wrap: true,
  );

  @override
  final ClassificationScoreCreatingContext<E> $value;

  @override
  ClassificationScoreCreatingContext<E> get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $ClassificationScoreCreatingContext.wrap(
      ClassificationScoreCreatingContext(
        entity: args[0]!.$value,
        playedCompetitions: args[1]!.$value,
        classificationScore: args[2]!.$value,
      ),
    );
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'entity':
        if ($value.entity is Jumper) {
          return $Jumper.wrap($value.entity as Jumper);
        } else if ($value.entity is CountryTeam) {
          return $CountryTeam.wrap($value.entity as CountryTeam);
        } else if ($value.entity is Team) {
          return $Team.wrap($value.entity as Team);
        } else {
          throw UnsupportedError(
              'An unsupported entity type (classification score creating context\'s getProperty method)');
        }
      case 'playedCompetitions':
        return $List<E>.wrap($value.playedCompetitions.cast());
      /*case 'eventSeries':
        return; // TODO;*/
      case 'classificationScore':
        return $ClassificationScore.wrap($value.classificationScore);
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
  List<Competition> get playedCompetitions => $value.playedCompetitions;

  /* @override
  EventSeries get eventSeries => $value.eventSeries;*/ // TODO: Unhide it

  @override
  ClassificationScore get classificationScore => $value.classificationScore;
}
