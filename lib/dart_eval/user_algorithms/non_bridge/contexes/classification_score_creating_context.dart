import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/contexes/entity_related_algorithm_context.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/classification_score.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/classification_score.dart';
import 'package:sj_manager/models/user_algorithms/concrete/classification_score_creator.dart';

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
      $extends: $EntityRelatedAlgorithmContext.$type, // What with the E generic type?
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'entity'.param(const BridgeTypeRef.ref('E').annotate),
          'playedCompetitions'.param($List.$declaration.type.type.annotate),
          'classificationScore'
              .param($ClassificationScore.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'entity': BridgeFieldDef(const BridgeTypeRef.ref('E').annotate),
      'playedCompetitions': BridgeFieldDef($List.$declaration.type.type.annotate),
      //'eventSeries': BridgeFieldDef(),
      'classificationScore':
          BridgeFieldDef($ClassificationScore.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final ClassificationScoreCreatingContext $value;

  @override
  ClassificationScoreCreatingContext get $reified => $value;

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
        return $Object($value.entity);
      case 'playedCompetitions':
        print('played comps get');
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
