// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_jump.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleJump _$SimpleJumpFromJson(Map<String, dynamic> json) => SimpleJump(
      jumperNameAndSurname: json['jumperNameAndSurname'] as String,
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$SimpleJumpToJson(SimpleJump instance) =>
    <String, dynamic>{
      'jumperNameAndSurname': instance.jumperNameAndSurname,
      'distance': instance.distance,
    };
