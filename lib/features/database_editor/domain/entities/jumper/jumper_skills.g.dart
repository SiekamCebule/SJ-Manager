// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jumper_skills.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JumperSkills _$JumperSkillsFromJson(Map<String, dynamic> json) => JumperSkills(
      takeoffQuality: (json['takeoffQuality'] as num).toDouble(),
      flightQuality: (json['flightQuality'] as num).toDouble(),
      landingQuality: (json['landingQuality'] as num).toDouble(),
    );

Map<String, dynamic> _$JumperSkillsToJson(JumperSkills instance) =>
    <String, dynamic>{
      'takeoffQuality': instance.takeoffQuality,
      'flightQuality': instance.flightQuality,
      'landingQuality': instance.landingQuality,
    };
