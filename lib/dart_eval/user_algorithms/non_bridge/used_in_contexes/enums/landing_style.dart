import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/user_db/jumper/landing_style.dart'; // Adjust the import path as necessary

class $LandingStyle implements $Instance {
  $LandingStyle.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'LandingStyle',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'perfect',
      'veryGraceful',
      'graceful',
      'average',
      'ugly',
      'veryUgly',
      'terrible',
    ],
  );

  static final $values = {
    'perfect': $LandingStyle.wrap(LandingStyle.perfect),
    'veryGraceful': $LandingStyle.wrap(LandingStyle.veryGraceful),
    'graceful': $LandingStyle.wrap(LandingStyle.graceful),
    'average': $LandingStyle.wrap(LandingStyle.average),
    'ugly': $LandingStyle.wrap(LandingStyle.ugly),
    'veryUgly': $LandingStyle.wrap(LandingStyle.veryUgly),
    'terrible': $LandingStyle.wrap(LandingStyle.terrible),
  };

  @override
  final LandingStyle $value;

  @override
  LandingStyle get $reified => $value;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'perfect':
        return $LandingStyle.wrap(LandingStyle.perfect);
      case 'veryGraceful':
        return $LandingStyle.wrap(LandingStyle.veryGraceful);
      case 'graceful':
        return $LandingStyle.wrap(LandingStyle.graceful);
      case 'average':
        return $LandingStyle.wrap(LandingStyle.average);
      case 'ugly':
        return $LandingStyle.wrap(LandingStyle.ugly);
      case 'veryUgly':
        return $LandingStyle.wrap(LandingStyle.veryUgly);
      case 'terrible':
        return $LandingStyle.wrap(LandingStyle.terrible);
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
