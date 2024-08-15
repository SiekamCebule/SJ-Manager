import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/jumps/simple_jump.dart';

class $SimpleJump implements SimpleJump, $Instance {
  $SimpleJump.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'SimpleJump',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
    ),
    getters: {},
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'jumperNameAndSurname'.param($String.$declaration.type.type.annotate),
          'distance'.param($double.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'jumperNameAndSurname': BridgeFieldDef($String.$declaration.type.type.annotate),
      'distance': BridgeFieldDef($double.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final SimpleJump $value;

  @override
  SimpleJump get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $SimpleJump.wrap(
      SimpleJump(
        jumperNameAndSurname: args[0]!.$value,
        distance: args[1]!.$value,
      ),
    );
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'jumperNameAndSurname':
        return $String($value.jumperNameAndSurname);
      case 'distance':
        return $double($value.distance);
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
  String get jumperNameAndSurname => $value.jumperNameAndSurname;

  @override
  double get distance => $value.distance;

  @override
  Json toJson() {
    throw UnimplementedError();
  }
}
