// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_facts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamFacts _$TeamFactsFromJson(Map<String, dynamic> json) => TeamFacts(
      stars: (json['stars'] as num).toInt(),
      record: SimpleJump.fromJson(json['record'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamFactsToJson(TeamFacts instance) => <String, dynamic>{
      'stars': instance.stars,
      'record': instance.record,
    };
