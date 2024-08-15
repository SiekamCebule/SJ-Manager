import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/bridge/unary_algorithm_bridge.dart';
import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/user_algorithms/user_algorithm.dart';

class $UserAlgorithm implements UserAlgorithm, $Instance {
  $UserAlgorithm.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'UserAlgorithm',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'id'.param(CoreTypes.string.ref.annotate),
          'name'.param(CoreTypes.string.ref.annotate),
          'description'.param(CoreTypes.string.ref.annotate),
          'algorithm'.param($UnaryAlgorithm$bridge.$type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'id': BridgeFieldDef(CoreTypes.string.ref.annotate),
      'name': BridgeFieldDef(CoreTypes.string.ref.annotate),
      'description': BridgeFieldDef(CoreTypes.string.ref.annotate),
      'algorithm': BridgeFieldDef($UnaryAlgorithm$bridge.$type.annotate),
    },
    wrap: true,
  );

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $UserAlgorithm.wrap(
      UserAlgorithm(
        id: args[0]!.$value,
        name: args[1]!.$value,
        description: args[2]!.$value,
        algorithm: args[3]!.$value,
      ),
    );
  }

  @override
  final UserAlgorithm $value;

  @override
  UserAlgorithm get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'name':
        return $String($value.name);
      case 'id':
        return $String($value.id);
      case 'description':
        return $String($value.description);
      case 'algorithm':
        return $UnaryAlgorithm$bridge.$new(runtime, $String(''), []);
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
  String get id => $value.id;

  @override
  String get name => $value.name;

  @override
  String get description => $value.description;

  @override
  UnaryAlgorithm get algorithm => $value.algorithm;
}
