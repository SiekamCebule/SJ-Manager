import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/bridge/unary_algorithm_bridge.dart';
import 'package:sj_manager/models/user_algorithms/concrete_wrappers/concrete_wrappers.dart';
import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/user_algorithms/user_algorithm.dart';

class $UserAlgorithm<T extends UnaryAlgorithm> implements UserAlgorithm<T>, $Instance {
  $UserAlgorithm.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'UserAlgorithm',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      generics: {
        'T': BridgeGenericParam($extends: $UnaryAlgorithm$bridge.$type),
      },
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'id'.param(CoreTypes.string.ref.annotate),
          'name'.param(CoreTypes.string.ref.annotate),
          'description'.param(CoreTypes.string.ref.annotate),
          'algorithm'.param(const BridgeTypeRef.ref('T').annotate),
        ],
      ).asConstructor
    },
    fields: {
      'id': BridgeFieldDef(CoreTypes.string.ref.annotate),
      'name': BridgeFieldDef(CoreTypes.string.ref.annotate),
      'description': BridgeFieldDef(CoreTypes.string.ref.annotate),
      'algorithm': BridgeFieldDef(const BridgeTypeRef.ref('T').annotate),
    },
    wrap: true,
  );

  static $Value? $new<T extends UnaryAlgorithm>(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $UserAlgorithm.wrap(
      UserAlgorithm<T>(
        id: args[0]!.$value,
        name: args[1]!.$value,
        description: args[2]!.$value,
        algorithm: args[3]!.$value as T,
      ),
    );
  }

  UserAlgorithm<ClassificationScoreCreatorWrapper>
      get classificationScoreCreatorAlgorithm {
    final copied = $value
        .cast<ClassificationScoreCreatorWrapper>()
        .copyWith(algorithm: ClassificationScoreCreatorWrapper.wrap(algorithm));
    return copied;
  }

  @override
  final UserAlgorithm<T> $value;

  @override
  UserAlgorithm<T> get $reified => $value;

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
        return $Object($value);
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
  T get algorithm => $value.algorithm;

  @override
  UserAlgorithm<T> copyWith(
      {String? id, String? name, String? description, T? algorithm}) {
    return $value.copyWith(
      id: id,
      name: name,
      description: description,
      algorithm: algorithm,
    );
  }

  @override
  UserAlgorithm<R> cast<R extends UnaryAlgorithm>() {
    return $value.cast<R>();
  }
}
