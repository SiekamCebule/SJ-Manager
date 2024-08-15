import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';

class $ValueRepo<T> implements ValueRepo<T>, $Instance {
  $ValueRepo.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'ValueRepo',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      generics: {
        'T': const BridgeGenericParam(),
      },
    ),
    getters: {
      'items':
          BridgeFunctionDef(returns: $Object.$declaration.type.type.annotate).asMethod,
      'last': BridgeFunctionDef(returns: $Map.$declaration.type.type.annotate).asMethod,
    },
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'initial'.paramOptional(const BridgeTypeRef.ref('T').annotate),
        ],
      ).asConstructor
    },
    fields: {},
    wrap: true,
  );

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $ValueRepo.wrap(
      ValueRepo(
        initial: args.isNotEmpty ? args[0]!.$value : null,
      ),
    );
  }

  @override
  final ValueRepo<T> $value;

  @override
  ValueRepo<T> get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'last':
        return $value.last != null ? $Object($value.last!) : const $null();
      case 'items':
        throw UnimplementedError();
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
  void dispose() {
    $value.dispose();
  }

  @override
  void set(T value) {
    $value.set(value);
  }

  @override
  ValueStream<T> get items => throw UnimplementedError();

  @override
  T get last => $value.last;
}
