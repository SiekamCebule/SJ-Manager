// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jumper_skills_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JumperSkillsModel _$JumperSkillsModelFromJson(Map<String, dynamic> json) =>
    JumperSkillsModel(
      takeoffQuality: (json['takeoffQuality'] as num).toDouble(),
      flightQuality: (json['flightQuality'] as num).toDouble(),
      landingQuality: (json['landingQuality'] as num).toDouble(),
    );

Map<String, dynamic> _$JumperSkillsModelToJson(JumperSkillsModel instance) =>
    <String, dynamic>{
      'takeoffQuality': instance.takeoffQuality,
      'flightQuality': instance.flightQuality,
      'landingQuality': instance.landingQuality,
    };
