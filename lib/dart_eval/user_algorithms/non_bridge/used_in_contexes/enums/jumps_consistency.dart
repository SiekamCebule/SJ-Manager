import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/user_db/jumper/jumps_consistency.dart'; // Adjust the import path as necessary

class $JumpsConsistency implements $Instance {
  $JumpsConsistency.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'JumpsConsistency',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'veryConsistent',
      'consistent',
      'average',
      'inconsistent',
      'veryInconsistent',
    ],
  );

  static final $values = {
    'veryConsistent': $JumpsConsistency.wrap(JumpsConsistency.veryConsistent),
    'consistent': $JumpsConsistency.wrap(JumpsConsistency.consistent),
    'average': $JumpsConsistency.wrap(JumpsConsistency.average),
    'inconsistent': $JumpsConsistency.wrap(JumpsConsistency.inconsistent),
    'veryInconsistent': $JumpsConsistency.wrap(JumpsConsistency.veryInconsistent),
  };

  @override
  final JumpsConsistency $value;

  @override
  JumpsConsistency get $reified => $value;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'veryConsistent':
        return $JumpsConsistency.wrap(JumpsConsistency.veryConsistent);
      case 'consistent':
        return $JumpsConsistency.wrap(JumpsConsistency.consistent);
      case 'average':
        return $JumpsConsistency.wrap(JumpsConsistency.average);
      case 'inconsistent':
        return $JumpsConsistency.wrap(JumpsConsistency.inconsistent);
      case 'veryInconsistent':
        return $JumpsConsistency.wrap(JumpsConsistency.veryInconsistent);
      default:
        return null;
    }
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    throw UnimplementedError();
  }
}
