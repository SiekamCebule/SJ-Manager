import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/country.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/sex.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/team.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/team_facts.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/country/team_facts.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/country_team.dart';

class $CountryTeam implements CountryTeam, $Instance {
  $CountryTeam.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'CountryTeam',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $extends: $Team.$type,
    ),
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
    },
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'facts'.param($TeamFacts.$declaration.type.type.annotate),
          'sex'.param($Sex.$declaration.type.annotate),
          'country'.param($Country.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'facts': BridgeFieldDef($TeamFacts.$declaration.type.type.annotate),
      'sex': BridgeFieldDef($Sex.$declaration.type.annotate),
      'country': BridgeFieldDef($Country.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final CountryTeam $value;

  @override
  CountryTeam get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $CountryTeam.wrap(
      CountryTeam(
        facts: args[0]!.$value,
        sex: args[1]!.$value,
        country: args[2]!.$value,
      ),
    );
  }

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'props':
        return $List.wrap($value.props);
      case 'stringify':
        return $bool($value.stringify ?? false);
      case 'facts':
        return $TeamFacts.wrap($value.facts);
      case 'sex':
        return $Sex.wrap($value.sex);
      case 'country':
        return $Country.wrap($value.country);
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
  TeamFacts get facts => $value.facts;

  @override
  Sex get sex => $value.sex;

  @override
  Country get country => $value.country;

  @override
  CountryTeam copyWith({TeamFacts? facts, Sex? sex, Country? country}) {
    return $value.copyWith(facts: facts, sex: sex, country: country);
  }

  @override
  Json toJson({required JsonCountrySaver countrySaver}) {
    throw UnimplementedError();
  }
}
