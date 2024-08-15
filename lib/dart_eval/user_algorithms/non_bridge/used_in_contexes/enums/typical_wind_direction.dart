import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/user_db/hill/typical_wind_direction.dart';

class $TypicalWindDirection implements $Instance {
  $TypicalWindDirection.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'TypicalWindDirection',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'headwind',
      'leftHeadwind',
      'rightHeadwind',
      'leftWind',
      'rightWind',
      'leftTailwind',
      'rightTailwind',
      'tailwind',
    ],
  );

  static final $values = {
    'headwind': $TypicalWindDirection.wrap(TypicalWindDirection.headwind),
    'leftHeadwind': $TypicalWindDirection.wrap(TypicalWindDirection.leftHeadwind),
    'rightHeadwind': $TypicalWindDirection.wrap(TypicalWindDirection.rightHeadwind),
    'leftWind': $TypicalWindDirection.wrap(TypicalWindDirection.leftWind),
    'rightWind': $TypicalWindDirection.wrap(TypicalWindDirection.rightWind),
    'leftTailwind': $TypicalWindDirection.wrap(TypicalWindDirection.leftTailwind),
    'rightTailwind': $TypicalWindDirection.wrap(TypicalWindDirection.rightTailwind),
    'tailwind': $TypicalWindDirection.wrap(TypicalWindDirection.tailwind),
  };

  @override
  final TypicalWindDirection $value;

  @override
  TypicalWindDirection get $reified => $value;

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
