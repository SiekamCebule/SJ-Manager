import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';
import 'package:dart_eval/dart_eval_extensions.dart';

class $UnaryAlgorithm$bridge<I, O>
    with $Bridge<UnaryAlgorithm<I, O>>
    implements UnaryAlgorithm<I, O> {
  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'UnaryAlgorithm',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      isAbstract: true,
      generics: {
        'I': const BridgeGenericParam(),
        'O': const BridgeGenericParam(),
      },
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
      ).asConstructor
    },
    methods: {
      'compute': BridgeFunctionDef(
        returns: const BridgeTypeAnnotation(
          BridgeTypeRef.ref('O'),
        ),
        params: [
          'I'.param(
            const BridgeTypeAnnotation(BridgeTypeRef.ref('I')),
          ),
        ],
      ).asMethod
    },
    bridge: true,
  );

  @override
  $Value? $bridgeGet(String identifier) {
    throw UnimplementedError();
  }

  @override
  void $bridgeSet(
    String identifier,
    $Value value,
  ) {
    throw UnimplementedError(
      'Cannot set property "$identifier" on abstract class WorldTimeTracker',
    );
  }

  @override
  O compute(I input) {
    throw UnimplementedError();
  }
}
