part of '../../models/user_db/hill/hill.dart';

Hill _hillFromJson(Map<String, dynamic> json,
        {required JsonCountryLoader countryLoader}) =>
    Hill(
      name: json['name'] as String,
      locality: json['locality'] as String,
      country: countryLoader.load(json['country']),
      k: (json['k'] as num).toDouble(),
      hs: (json['hs'] as num).toDouble(),
      landingEase: $enumDecode(_$LandingEaseEnumMap, json['landingEase']),
      profileType: $enumDecode(_$HillProfileTypeEnumMap, json['profileType']),
      jumpsVariability: $enumDecode(_$JumpsVariabilityEnumMap, json['jumpsVariability']),
      typicalWindDirection: $enumDecodeNullable(
          _$TypicalWindDirectionEnumMap, json['typicalWindDirection']),
      typicalWindStrength: (json['typicalWindStrength'] as num?)?.toDouble(),
      pointsForGate: (json['pointsForGate'] as num).toDouble(),
      pointsForHeadwind: (json['pointsForHeadwind'] as num).toDouble(),
      pointsForTailwind: (json['pointsForTailwind'] as num).toDouble(),
    );

Map<String, dynamic> _hillToJson(Hill instance,
        {required JsonCountrySaver countrySaver}) =>
    <String, dynamic>{
      'name': instance.name,
      'locality': instance.locality,
      'country': countrySaver.save(instance.country),
      'k': instance.k,
      'hs': instance.hs,
      'landingEase': _$LandingEaseEnumMap[instance.landingEase]!,
      'profileType': _$HillProfileTypeEnumMap[instance.profileType]!,
      'jumpsVariability': _$JumpsVariabilityEnumMap[instance.jumpsVariability]!,
      if (instance.typicalWindDirection != null)
        'typicalWindDirection':
            _$TypicalWindDirectionEnumMap[instance.typicalWindDirection],
      if (instance.typicalWindStrength != null)
        'typicalWindStrength': instance.typicalWindStrength,
      'pointsForGate': instance.pointsForGate,
      'pointsForHeadwind': instance.pointsForHeadwind,
      'pointsForTailwind': instance.pointsForTailwind,
    };

const _$LandingEaseEnumMap = {
  LandingEase.veryHigh: 3,
  LandingEase.high: 2,
  LandingEase.fairlyHigh: 1,
  LandingEase.average: 0,
  LandingEase.fairlyLow: -1,
  LandingEase.low: -2,
  LandingEase.veryLow: -3,
};

const _$HillProfileTypeEnumMap = {
  HillProfileType.highlyFavorsInFlight: 2,
  HillProfileType.favorsInFlight: 1,
  HillProfileType.balanced: 0,
  HillProfileType.favorsInTakeoff: -1,
  HillProfileType.highlyFavorsInTakeoff: -2,
};

const _$JumpsVariabilityEnumMap = {
  JumpsVariability.highlyVariable: 2,
  JumpsVariability.variable: 1,
  JumpsVariability.average: 0,
  JumpsVariability.stable: -1,
  JumpsVariability.highlyStable: -2,
};

const _$TypicalWindDirectionEnumMap = {
  TypicalWindDirection.headwind: 'headwind',
  TypicalWindDirection.leftHeadwind: 'leftHeadwind',
  TypicalWindDirection.rightHeadwind: 'rightHeadwind',
  TypicalWindDirection.leftWind: 'leftWind',
  TypicalWindDirection.rightWind: 'rightWind',
  TypicalWindDirection.leftTailwind: 'leftTailwind',
  TypicalWindDirection.rightTailwind: 'rightTailwind',
  TypicalWindDirection.tailwind: 'tailwind',
};
