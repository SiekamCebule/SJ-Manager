import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/equatable_mixin.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/country/country.dart';

class $Country implements Country, $Instance {
  $Country.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'Country',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $with: [$EquatableMixin.$type],
    ),
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod
    },
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'code'.param($String.$declaration.type.type.annotate),
          'name'.param($String.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'code': BridgeFieldDef($String.$declaration.type.type.annotate),
      'name': BridgeFieldDef($String.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $Country.wrap(
      Country(
        code: args[0]!.$value,
        name: args[1]!.$value,
      ),
    );
  }

  @override
  final Country $value;

  @override
  Country get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'code':
        return $String($value.code);
      case 'name':
        return $String($value.name);
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
  List<Object?> get props => $value.props;

  @override
  bool? get stringify => $value.stringify;

  @override
  String get code => $value.code;

  @override
  String get name => $value.name;

  @override
  Country copyWith({String? code, String? name}) {
    throw UnimplementedError();
  }

  @override
  Json toJson() {
    throw UnimplementedError();
  }
}
