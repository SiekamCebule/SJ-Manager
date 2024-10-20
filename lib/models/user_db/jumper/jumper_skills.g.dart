// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jumper_skills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JumperSkills _$JumperSkillsFromJson(Map<String, dynamic> json) => JumperSkills(
      takeoffQuality: (json['takeoffQuality'] as num).toDouble(),
      flightQuality: (json['flightQuality'] as num).toDouble(),
      landingQuality: (json['landingQuality'] as num).toDouble(),
      jumpingStyle: $enumDecode(_$JumpingStyleEnumMap, json['jumpingStyle']),
    );

Map<String, dynamic> _$JumperSkillsToJson(JumperSkills instance) => <String, dynamic>{
      'takeoffQuality': instance.takeoffQuality,
      'flightQuality': instance.flightQuality,
      'landingQuality': instance.landingQuality,
      'jumpingStyle': _$JumpingStyleEnumMap[instance.jumpingStyle]!,
    };

const _$JumpingStyleEnumMap = {
  JumpingStyle.veryDefensive: 'veryDefensive',
  JumpingStyle.clearlyDefensive: 'clearlyDefensive',
  JumpingStyle.defensive: 'fairlyDefensive',
  JumpingStyle.cautious: 'cautious',
  JumpingStyle.slightlyCautious: 'slightlyCautious',
  JumpingStyle.balanced: 'balanced',
  JumpingStyle.fairlyUnpredictable: 'fairlyUnpredictable',
  JumpingStyle.unpredictable: 'unpredictable',
  JumpingStyle.risky: 'fairlyRisky',
  JumpingStyle.clearlyRisky: 'clearlyRisky',
  JumpingStyle.veryRisky: 'veryRisky',
};
