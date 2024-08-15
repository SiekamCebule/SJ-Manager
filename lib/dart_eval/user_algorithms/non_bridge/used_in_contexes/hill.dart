import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/dart_eval_extensions.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/country.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/hill_profile_type.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/hill_type_by_size.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/jumps_variability.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/landing_ease.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/enums/typical_wind_direction.dart';
import 'package:sj_manager/dart_eval/user_algorithms/non_bridge/used_in_contexes/equatable_mixin.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/hill/hill_profile_type.dart';
import 'package:sj_manager/models/user_db/hill/hill_type_by_size.dart';
import 'package:sj_manager/models/user_db/hill/jumps_variability.dart';
import 'package:sj_manager/models/user_db/hill/landing_ease.dart';
import 'package:sj_manager/models/user_db/hill/typical_wind_direction.dart';

class $Hill implements Hill, $Instance {
  $Hill.wrap(this.$value) : _superclass = $Object($value);

  static final $type = const BridgeTypeSpec(
    'package:sj_manager/bridge.dart',
    'Hill',
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
          'name'.param($String.$declaration.type.type.annotate),
          'locality'.param($String.$declaration.type.type.annotate),
          'country'.param($Country.$declaration.type.type.annotate),
          'k'.param($double.$declaration.type.type.annotate),
          'hs'.param($double.$declaration.type.type.annotate),
          'landingEase'.param($LandingEase.$declaration.type.annotate),
          'profileType'.param($HillProfileType.$declaration.type.annotate),
          'jumpsVariability'.param($JumpsVariability.$declaration.type.annotate),
          'typicalWindDirection'.param($TypicalWindDirection.$declaration.type.annotate),
          'typicalWindStrength'.param($double.$declaration.type.type.annotate),
          'pointsForGate'.param($double.$declaration.type.type.annotate),
          'pointsForHeadwind'.param($double.$declaration.type.type.annotate),
          'pointsForTailwind'.param($double.$declaration.type.type.annotate),
        ],
      ).asConstructor
    },
    fields: {
      'name': BridgeFieldDef($String.$declaration.type.type.annotate),
      'locality': BridgeFieldDef($String.$declaration.type.type.annotate),
      'country': BridgeFieldDef($Country.$declaration.type.type.annotate),
      'k': BridgeFieldDef($double.$declaration.type.type.annotate),
      'hs': BridgeFieldDef($double.$declaration.type.type.annotate),
      'landingEase': BridgeFieldDef($LandingEase.$declaration.type.annotate),
      'profileType': BridgeFieldDef($HillProfileType.$declaration.type.annotate),
      'jumpsVariability': BridgeFieldDef($JumpsVariability.$declaration.type.annotate),
      'typicalWindDirection':
          BridgeFieldDef($TypicalWindDirection.$declaration.type.annotate),
      'typicalWindStrength': BridgeFieldDef($double.$declaration.type.type.annotate),
      'pointsForGate': BridgeFieldDef($double.$declaration.type.type.annotate),
      'pointsForHeadwind': BridgeFieldDef($double.$declaration.type.type.annotate),
      'pointsForTailwind': BridgeFieldDef($double.$declaration.type.type.annotate),
    },
    wrap: true,
  );

  @override
  final Hill $value;

  @override
  Hill get $reified => $value;

  final $Instance _superclass;

  static $Value? $new(Runtime runtime, $Value? target, List<$Value?> args) {
    return $Hill.wrap(
      Hill(
        name: args[0]!.$value,
        locality: args[1]!.$value,
        country: args[2]!.$value,
        k: args[3]!.$value,
        hs: args[4]!.$value,
        landingEase: args[5]!.$value,
        profileType: args[6]!.$value,
        jumpsVariability: args[7]!.$value,
        typicalWindDirection: args[8]?.$value,
        typicalWindStrength: args[9]?.$value,
        pointsForGate: args[10]!.$value,
        pointsForHeadwind: args[11]!.$value,
        pointsForTailwind: args[12]!.$value,
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
      case 'name':
        return $String($value.name);
      case 'locality':
        return $String($value.locality);
      case 'country':
        return $Country.wrap($value.country);
      case 'k':
        return $double($value.k);
      case 'hs':
        return $double($value.hs);
      case 'landingEase':
        return $LandingEase.wrap($value.landingEase);
      case 'profileType':
        return $HillProfileType.wrap($value.profileType);
      case 'jumpsVariability':
        return $JumpsVariability.wrap($value.jumpsVariability);
      case 'typicalWindDirection':
        return $value.typicalWindDirection != null
            ? $TypicalWindDirection.wrap($value.typicalWindDirection!)
            : const $null();
      case 'typicalWindStrength':
        return $value.typicalWindStrength != null
            ? $double($value.typicalWindStrength!)
            : const $null();
      case 'pointsForGate':
        return $double($value.pointsForGate);
      case 'pointsForHeadwind':
        return $double($value.pointsForHeadwind);
      case 'pointsForTailwind':
        return $double($value.pointsForTailwind);
      case 'typeBySize':
        return $HillTypeBySize.wrap($value.typeBySize);
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

  // TODO: MAYBE WRAP THE VALUES? LIKE COUNTRY.WRAP($VALUE.STH)
  @override
  List<Object?> get props => $value.props;

  @override
  bool? get stringify => $value.stringify;

  @override
  String get name => $value.name;

  @override
  String get locality => $value.locality;

  @override
  Country get country => $value.country;

  @override
  double get k => $value.k;

  @override
  double get hs => $value.hs;

  @override
  LandingEase get landingEase => $value.landingEase;

  @override
  HillProfileType get profileType => $value.profileType;

  @override
  JumpsVariability get jumpsVariability => $value.jumpsVariability;

  @override
  TypicalWindDirection? get typicalWindDirection => $value.typicalWindDirection;

  @override
  double? get typicalWindStrength => $value.typicalWindStrength;

  @override
  double get pointsForGate => $value.pointsForGate;

  @override
  double get pointsForHeadwind => $value.pointsForHeadwind;

  @override
  double get pointsForTailwind => $value.pointsForTailwind;

  @override
  HillTypeBySize get typeBySize => $value.typeBySize;

  @override
  Hill copyWith(
      {String? name,
      String? locality,
      Country? country,
      double? k,
      double? hs,
      LandingEase? landingEase,
      HillProfileType? profileType,
      JumpsVariability? jumpsVariability,
      TypicalWindDirection? typicalWindDirection,
      double? typicalWindStrength,
      double? pointsForGate,
      double? pointsForHeadwind,
      double? pointsForTailwind}) {
    throw UnimplementedError();
  }

  @override
  Json toJson({required JsonCountrySaver countrySaver}) {
    throw UnimplementedError();
  }
}
