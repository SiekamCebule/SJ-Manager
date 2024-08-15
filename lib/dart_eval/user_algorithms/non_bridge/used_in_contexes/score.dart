import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/equatable_mixin.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

class $Score<E> implements Score<E>, $Instance {
  $Score.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'Score',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      generics: {
        'E': const BridgeGenericParam(),
      },
      $with: [$EquatableMixin.$type],
      isAbstract: true,
    ),
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod
    },
    methods: {
      'operator>':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'operator<':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'compareTo': BridgeFunctionDef(
        returns: $int.$declaration.type.type.annotate,
        params: [
          BridgeParameter('', $Object.$declaration.type.type.annotate, false),
        ],
      ).asMethod,
    },
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
  final Score $value;

  @override
  Score get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'entity':
        return $Object($value.entity);
      case 'props':
        return $List.wrap($value.props);
      case 'stringify':
        return $bool($value.stringify ?? false);
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

  @override
  int compareTo(other) {
    return $value.compareTo(other);
  }

  @override
  List<Object?> get props => $value.props;

  @override
  bool? get stringify => $value.stringify;

  @override
  bool operator >(other) {
    return $value > other;
  }

  @override
  bool operator <(other) {
    return $value < other;
  }
}
