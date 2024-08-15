import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/models/user_algorithms/entity_related_algorithm_context.dart';

class $EntityRelatedAlgorithmContext<E>
    implements EntityRelatedAlgorithmContext<E>, $Instance {
  $EntityRelatedAlgorithmContext.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'EntityRelatedAlgorithmContext',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      generics: {
        'E': const BridgeGenericParam(),
      },
      isAbstract: true,
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'entity'.param(const BridgeTypeRef.ref('E').annotate),
        ],
      ).asConstructor
    },
    fields: {
      'entity': BridgeFieldDef(const BridgeTypeRef.ref('E').annotate),
    },
    wrap: true,
  );

  @override
  final EntityRelatedAlgorithmContext $value;

  @override
  EntityRelatedAlgorithmContext get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'entity':
        return $Object($value.entity);
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
  E get entity => $value.entity;
}
