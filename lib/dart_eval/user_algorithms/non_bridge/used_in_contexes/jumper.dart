import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/country.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/hill_profile_type.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/hill_type_by_size.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/jumps_variability.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/landing_ease.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/sex.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/typical_wind_direction.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/equatable_mixin.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/jumper_skills.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/sex.dart';

class $Jumper implements Jumper, $Instance {
  $Jumper.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'Jumper',
  ).ref;

  static final $declaration = BridgeClassDef(
    BridgeClassType(
      $type,
      $with: [$EquatableMixin.$type],
    ),
    getters: {
      'props': BridgeFunctionDef(returns: $List.$declaration.type.type.annotate).asMethod,
      'stringify':
          BridgeFunctionDef(returns: $bool.$declaration.type.type.annotate).asMethod,
      'typeBySize':
          BridgeFunctionDef(returns: $HillTypeBySize.$declaration.type.annotate).asMethod,
    },
    constructors: {
      '': BridgeFunctionDef(
        returns: $type.annotate,
        namedParams: [
          'age'.param($int.$declaration.type.type.annotate),
          'name'.param($String.$declaration.type.type.annotate),
          'surname'.param($String.$declaration.type.type.annotate),
          'country'.param($Country.$declaration.type.type.annotate),
          'sex'.param($Sex.$declaration.type.annotate),
          'skills'.param($JumperSkills.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'age': BridgeFieldDef($int.$declaration.type.type.annotate),
      'name': BridgeFieldDef($String.$declaration.type.type.annotate),
      'surname': BridgeFieldDef($String.$declaration.type.type.annotate),
      'country': BridgeFieldDef($Country.$declaration.type.type.annotate),
      'sex': BridgeFieldDef($Sex.$declaration.type.annotate),
      'skills': BridgeFieldDef($JumperSkills.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final Jumper $value;

  @override
  Jumper get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $Jumper.wrap(
      Jumper(
        age: args[0]!.$value,
        name: args[1]!.$value,
        surname: args[1]!.$value,
        country: args[1]!.$value,
        sex: args[1]!.$value,
        skills: args[1]!.$value,
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
      case 'age':
        return $int($value.age);
      case 'name':
        return $String($value.name);
      case 'surname':
        return $String($value.surname);
      case 'country':
        return $Country.wrap($value.country);
      case 'sex':
        return $Sex.wrap($value.sex);
      case 'skills':
        return $JumperSkills.wrap($value.skills);
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
  int get age => $value.age;

  @override
  String get name => $value.name;

  @override
  String get surname => $value.surname;

  @override
  Sex get sex => $value.sex;

  @override
  JumperSkills get skills => $JumperSkills.wrap($value.skills);

  @override
  Country get country => $value.country;

  @override
  String nameAndSurname({bool capitalizeSurname = false, bool reverse = false}) {
    return $value.nameAndSurname(capitalizeSurname: capitalizeSurname, reverse: reverse);
  }

  @override
  Jumper copyWith(
      {int? age,
      String? name,
      String? surname,
      Country? country,
      Sex? sex,
      JumperSkills? skills}) {
    return $value.copyWith(
      age: age,
      name: name,
      surname: surname,
      sex: sex,
      skills: skills,
    );
  }

  @override
  Json toJson({required JsonCountrySaver countrySaver}) {
    throw UnimplementedError();
  }
}
