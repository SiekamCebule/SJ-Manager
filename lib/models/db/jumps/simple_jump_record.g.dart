// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_jump_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleJumpRecord _$SimpleJumpRecordFromJson(Map<String, dynamic> json) =>
    SimpleJumpRecord(
      jumperNameAndSurname: json['jumperNameAndSurname'] as String,
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$SimpleJumpRecordToJson(SimpleJumpRecord instance) =>
    <String, dynamic>{
      'jumperNameAndSurname': instance.jumperNameAndSurname,
      'distance': instance.distance,
    };
