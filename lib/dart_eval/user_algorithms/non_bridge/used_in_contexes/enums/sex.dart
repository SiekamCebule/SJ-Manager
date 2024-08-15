import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/user_db/sex.dart'; // Adjust the import path as necessary

class $Sex implements $Instance {
  $Sex.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'Sex',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'male',
      'female',
    ],
  );

  static final $values = {
    'male': $Sex.wrap(Sex.male),
    'female': $Sex.wrap(Sex.female),
  };

  @override
  final Sex $value;

  @override
  Sex get $reified => $value;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'male':
        return $Sex.wrap(Sex.male);
      case 'female':
        return $Sex.wrap(Sex.female);
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
