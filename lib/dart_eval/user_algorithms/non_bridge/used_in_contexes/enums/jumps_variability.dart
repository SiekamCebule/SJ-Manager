import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/user_db/hill/jumps_variability.dart';

class $JumpsVariability implements $Instance {
  $JumpsVariability.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'JumpsVariability',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'highlyVariable',
      'variable',
      'average',
      'stable',
      'highlyStable',
    ],
  );

  static final $values = {
    'highlyVariable': $JumpsVariability.wrap(JumpsVariability.highlyVariable),
    'variable': $JumpsVariability.wrap(JumpsVariability.variable),
    'average': $JumpsVariability.wrap(JumpsVariability.average),
    'stable': $JumpsVariability.wrap(JumpsVariability.stable),
    'highlyStable': $JumpsVariability.wrap(JumpsVariability.highlyStable),
  };

  @override
  final JumpsVariability $value;

  @override
  JumpsVariability get $reified => $value;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    throw UnimplementedError();
  }

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($type.spec!);

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    throw UnimplementedError();
  }
}
