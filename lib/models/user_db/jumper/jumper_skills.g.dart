// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jumper_skills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JumperSkills _$JumperSkillsFromJson(Map<String, dynamic> json) => JumperSkills(
      takeoffQuality: (json['takeoffQuality'] as num).toDouble(),
      flightQuality: (json['flightQuality'] as num).toDouble(),
      landingQuality: (json['landingQuality'] as num).toDouble(),
      jumpingTechnique: $enumDecode(_$JumpingStyleEnumMap, json['jumpingTechnique']),
    );

Map<String, dynamic> _$JumperSkillsToJson(JumperSkills instance) => <String, dynamic>{
      'takeoffQuality': instance.takeoffQuality,
      'flightQuality': instance.flightQuality,
      'landingQuality': instance.landingQuality,
      'jumpingTechnique': _$JumpingStyleEnumMap[instance.jumpingTechnique]!,
    };

const _$JumpingStyleEnumMap = {
  JumpingTechnique.veryDefensive: 'veryDefensive',
  JumpingTechnique.clearlyDefensive: 'clearlyDefensive',
  JumpingTechnique.defensive: 'fairlyDefensive',
  JumpingTechnique.cautious: 'cautious',
  JumpingTechnique.slightlyCautious: 'slightlyCautious',
  JumpingTechnique.balanced: 'balanced',
  JumpingTechnique.fairlyUnpredictable: 'fairlyUnpredictable',
  JumpingTechnique.unpredictable: 'unpredictable',
  JumpingTechnique.risky: 'fairlyRisky',
  JumpingTechnique.clearlyRisky: 'clearlyRisky',
  JumpingTechnique.veryRisky: 'veryRisky',
};
