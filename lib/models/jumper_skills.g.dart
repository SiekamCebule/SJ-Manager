// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jumper_skills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JumperSkills _$JumperSkillsFromJson(Map<String, dynamic> json) => JumperSkills(
      qualityOnSmallerHills: (json['qualityOnSmallerHills'] as num).toDouble(),
      qualityOnLargerHills: (json['qualityOnLargerHills'] as num).toDouble(),
      landingStyle: $enumDecode(_$LandingStyleEnumMap, json['landingStyle']),
      jumpsConsistency: $enumDecode(_$JumpsConsistencyEnumMap, json['jumpsConsistency']),
    );

Map<String, dynamic> _$JumperSkillsToJson(JumperSkills instance) => <String, dynamic>{
      'qualityOnSmallerHills': instance.qualityOnSmallerHills,
      'qualityOnLargerHills': instance.qualityOnLargerHills,
      'landingStyle': _$LandingStyleEnumMap[instance.landingStyle]!,
      'jumpsConsistency': _$JumpsConsistencyEnumMap[instance.jumpsConsistency]!,
    };

const _$LandingStyleEnumMap = {
  LandingStyle.perfect: 3,
  LandingStyle.veryGraceful: 2,
  LandingStyle.graceful: 1,
  LandingStyle.average: 0,
  LandingStyle.ugly: -1,
  LandingStyle.veryUgly: -2,
  LandingStyle.terrible: -3,
};

const _$JumpsConsistencyEnumMap = {
  JumpsConsistency.veryConsistent: 2,
  JumpsConsistency.consistent: 1,
  JumpsConsistency.average: 0,
  JumpsConsistency.inconsistent: -1,
  JumpsConsistency.veryInconsistent: -2,
};
