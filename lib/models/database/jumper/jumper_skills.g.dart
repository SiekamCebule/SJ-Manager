// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jumper_skills_db_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JumperSkillsDbRecord _$JumperSkillsFromJson(Map<String, dynamic> json) =>
    JumperSkillsDbRecord(
      takeoffQuality: (json['takeoffQuality'] as num).toDouble(),
      flightQuality: (json['flightQuality'] as num).toDouble(),
      landingQuality: (json['landingQuality'] as num).toDouble(),
    );

Map<String, dynamic> _$JumperSkillsToJson(JumperSkillsDbRecord instance) =>
    <String, dynamic>{
      'takeoffQuality': instance.takeoffQuality,
      'flightQuality': instance.flightQuality,
      'landingQuality': instance.landingQuality,
    };
