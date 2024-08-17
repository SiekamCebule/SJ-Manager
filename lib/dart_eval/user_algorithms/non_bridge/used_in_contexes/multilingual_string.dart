import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/equatable_mixin.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class $MultilingualString implements MultilingualString, $Instance {
  $MultilingualString.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'MultilingualString',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $with: [$EquatableMixin.$type],
    ),
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'namesByLanguage'.param(
            BridgeTypeRef(CoreTypes.map, [CoreTypes.string.ref, CoreTypes.string.ref])
                .annotate,
          ),
        ],
      ).asConstructor
    },
    fields: {
      'namesByLanguage': BridgeFieldDef(
        BridgeTypeRef(CoreTypes.map, [CoreTypes.string.ref, CoreTypes.string.ref])
            .annotate,
      ),
    },
    wrap: true,
  );

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $MultilingualString.wrap(
      MultilingualString(
        namesByLanguage: args[0]!.$value,
      ),
    );
  }

  @override
  final MultilingualString $value;

  @override
  MultilingualString get $reified => $value;

  final $Instance _superclass;

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'namesByLanguage':
        return $Map.wrap($value.namesByLanguage);
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
  Json toJson() {
    throw UnimplementedError();
  }

  @override
  String byCode(String languageCode) {
    return $value.byCode(languageCode);
  }

  @override
  MultilingualString copyWith({required String languageCode, required String name}) {
    return $value.copyWith(languageCode: languageCode, name: name);
  }

  @override
  String translate(BuildContext context) {
    return $value.translate(context);
  }

  @override
  Map<String, String> get namesByLanguage => $value.namesByLanguage;
}
