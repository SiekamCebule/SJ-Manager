// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_team_facts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryTeamFacts _$TeamFactsFromJson(Map<String, dynamic> json) => CountryTeamFacts(
      stars: (json['stars'] as num).toInt(),
      record: json['record'] == null
          ? null
          : SimpleJump.fromJson(json['record'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamFactsToJson(CountryTeamFacts instance) => <String, dynamic>{
      'stars': instance.stars,
      'record': instance.record,
    };
