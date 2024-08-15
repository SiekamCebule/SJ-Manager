import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/user_db/hill/landing_ease.dart';

class $LandingEase implements $Instance {
  $LandingEase.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'LandingEase',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'veryHigh',
      'high',
      'failrlyHigh',
      'average',
      'fairlyLow',
      'low',
      'veryLow',
    ],
  );

  static final $values = {
    'veryHigh': $LandingEase.wrap(LandingEase.veryHigh),
    'high': $LandingEase.wrap(LandingEase.high),
    'fairlyHigh': $LandingEase.wrap(LandingEase.fairlyHigh),
    'average': $LandingEase.wrap(LandingEase.average),
    'fairlyLow': $LandingEase.wrap(LandingEase.fairlyLow),
    'low': $LandingEase.wrap(LandingEase.low),
    'veryLow': $LandingEase.wrap(LandingEase.veryLow),
  };

  @override
  final LandingEase $value;

  @override
  LandingEase get $reified => $value;

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
