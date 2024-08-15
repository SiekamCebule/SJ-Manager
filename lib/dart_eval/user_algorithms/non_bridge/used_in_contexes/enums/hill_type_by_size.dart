import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:sj_manager/models/user_db/hill/hill_type_by_size.dart';

class $HillTypeBySize implements $Instance {
  $HillTypeBySize.wrap(this.$value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'HillTypeBySize',
  ).ref;

  static final $declaration = BridgeEnumDef(
    $type,
    values: [
      'skiFlying',
      'big',
      'large',
      'normal',
      'medium',
      'small',
    ],
  );

  static final $values = {
    'skiFlying': $HillTypeBySize.wrap(HillTypeBySize.skiFlying),
    'big': $HillTypeBySize.wrap(HillTypeBySize.big),
    'large': $HillTypeBySize.wrap(HillTypeBySize.large),
    'normal': $HillTypeBySize.wrap(HillTypeBySize.normal),
    'medium': $HillTypeBySize.wrap(HillTypeBySize.medium),
    'small': $HillTypeBySize.wrap(HillTypeBySize.small),
  };

  @override
  final HillTypeBySize $value;

  @override
  HillTypeBySize get $reified => $value;

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
