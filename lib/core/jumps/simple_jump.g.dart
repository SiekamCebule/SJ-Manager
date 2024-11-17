// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_jump_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleJumpModel _$SimpleJumpFromJson(Map<String, dynamic> json) => SimpleJumpModel(
      jumperNameAndSurname: json['jumperNameAndSurname'] as String,
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$SimpleJumpToJson(SimpleJumpModel instance) => <String, dynamic>{
      'jumperNameAndSurname': instance.jumperNameAndSurname,
      'distance': instance.distance,
    };
