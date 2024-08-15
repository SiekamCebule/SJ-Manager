import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/sex.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/simple_jump.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/country/team_facts.dart';
import 'package:sj_manager/models/user_db/jumps/simple_jump.dart';

class $TeamFacts implements TeamFacts, $Instance {
  $TeamFacts.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'TeamFacts',
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
          'stars'.param($int.$declaration.type.type.annotate),
          'record'.param($Sex.$declaration.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'stars': BridgeFieldDef($int.$declaration.type.type.annotate),
      'record': BridgeFieldDef($SimpleJump.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final TeamFacts $value;

  @override
  TeamFacts get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $TeamFacts.wrap(
      TeamFacts(
        stars: args[0]!.$value,
        record: args[1]!.$value,
      ),
    );
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'stars':
        return $int($value.stars);
      case 'record':
        return $SimpleJump.wrap($value.record);
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
  int get stars => $value.stars;

  @override
  SimpleJump get record => $value.record;

  @override
  Json toJson() {
    throw UnimplementedError();
  }
}
