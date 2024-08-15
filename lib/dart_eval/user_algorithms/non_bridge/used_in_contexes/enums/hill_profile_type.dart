import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/user_db/hill/hill_profile_type.dart';

class $HillProfileType implements $Instance {
  $HillProfileType.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'HillProfileType',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'highlyFavorsInFlight',
      'favorsInFlight',
      'balanced',
      'favorsInTakeoff',
      'highlyFavorsInTakeoff',
    ],
  );

  static final $values = {
    'highlyFavorsInFlight': $HillProfileType.wrap(HillProfileType.highlyFavorsInFlight),
    'favorsInFlight': $HillProfileType.wrap(HillProfileType.favorsInFlight),
    'balanced': $HillProfileType.wrap(HillProfileType.balanced),
    'favorsInTakeoff': $HillProfileType.wrap(HillProfileType.favorsInTakeoff),
    'highlyFavorsInTakeoff': $HillProfileType.wrap(HillProfileType.highlyFavorsInTakeoff),
  };

  @override
  final HillProfileType $value;

  @override
  HillProfileType get $reified => $value;

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
