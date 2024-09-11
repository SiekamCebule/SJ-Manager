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
  LandingStyle.veryGraceful: 3,
  LandingStyle.graceful: 2,
  LandingStyle.quiteGraceful: 1,
  LandingStyle.average: 0,
  LandingStyle.slightlyUgly: -1,
  LandingStyle.ugly: -2,
  LandingStyle.veryUgly: -3,
};

const _$JumpsConsistencyEnumMap = {
  JumpsConsistency.veryConsistent: 2,
  JumpsConsistency.consistent: 1,
  JumpsConsistency.average: 0,
  JumpsConsistency.inconsistent: -1,
  JumpsConsistency.veryInconsistent: -2,
};
