import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/contexes/classification_score_creating_context.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/classification_score.dart';
import 'package:sj_manager/models/user_algorithms/concrete/classification_score_creator.dart';
import 'package:dart_eval/dart_eval_extensions.dart';

class $ClassificationScoreCreator$bridge
    with $Bridge<ClassificationScoreCreator>
    implements ClassificationScoreCreator {
  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'ClassificationScoreCreator',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
      ).asConstructor
    },
    methods: {
      'evaluate': BridgeFunctionDef(
        returns: $ClassificationScoreCreatingContext.$type.annotate,
        params: [
          BridgeParameter(
            '',
            $ClassificationScoreCreatingContext.$declaration.type.type.annotate,
            false,
          ),
        ],
      ).asMethod
    },
    bridge: true,
  );

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $ClassificationScoreCreator$bridge();
  }

  @override
  $Value? $bridgeGet(String identifier) {
    throw UnimplementedError();
  }

  @override
  void $bridgeSet(
    String identifier,
    $Value value,
  ) {
    throw UnimplementedError(
      'Cannot set property "$identifier" on abstract class WorldTimeTracker',
    );
  }

  @override
  ClassificationScore compute(ClassificationScoreCreatingContext input) {
    final result = $_invoke('compute', [
      $ClassificationScoreCreatingContext.wrap(input),
    ]);
    return result;
  }
}
