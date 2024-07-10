import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/enums/hill_type_by_size.dart';
import 'package:sj_manager/enums/typical_wind_direction.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/enums/hill_profile_type.dart';
import 'package:sj_manager/enums/jumps_variability.dart';
import 'package:sj_manager/enums/landing_ease.dart';

part '../../json/manual_json/hill_json.dart';

@JsonSerializable()
class Hill with EquatableMixin {
  const Hill({
    required this.name,
    required this.locality,
    required this.country,
    required this.k,
    required this.hs,
    required this.landingEase,
    required this.profileType,
    required this.jumpsVariability,
    this.typicalWindDirection,
    this.typicalWindStrength,
    required this.pointsForGate,
    required this.pointsForHeadwind,
    required this.pointsForTailwind,
  });

  factory Hill.empty({required Country defaultCountry}) {
    return Hill(
      name: '',
      locality: '',
      country: defaultCountry,
      k: 0,
      hs: 0,
      landingEase: LandingEase.average,
      profileType: HillProfileType.balanced,
      jumpsVariability: JumpsVariability.average,
      pointsForGate: 0,
      pointsForHeadwind: 0,
      pointsForTailwind: 0,
    );
  }

  final String name;
  final String locality;
  final Country country;

  final double k;
  final double hs;
  final LandingEase landingEase;
  final HillProfileType profileType;
  final JumpsVariability jumpsVariability;

  //@JsonKey(fromJson: Degrees.fromJson, toJson: Degrees.staticToJson)
  final TypicalWindDirection? typicalWindDirection;
  final double? typicalWindStrength;

  final double pointsForGate;
  final double pointsForHeadwind;
  final double pointsForTailwind;

  HillTypeBySize get typeBySize => HillTypeBySize.fromHsPoint(hs);

  Json toJson({required JsonCountrySaver countrySaver}) {
    return _hillToJson(this, countrySaver: countrySaver);
  }

  static Hill fromJson(Json json, {required JsonCountryLoader countryLoader}) {
    return _hillFromJson(json, countryLoader: countryLoader);
  }

  @override
  List<Object?> get props => [
        name,
        locality,
        country,
        k,
        hs,
        landingEase,
        profileType,
        jumpsVariability,
        typicalWindDirection,
        typicalWindStrength,
      ];
}
