// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_facts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryFacts _$CountryFactsFromJson(Map<String, dynamic> json) => CountryFacts(
      countryCode: json['countryCode'] as String,
      stars: (json['stars'] as num).toInt(),
      personalBest: SimpleJumpRecord.fromJson(
          json['personalBest'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CountryFactsToJson(CountryFacts instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'stars': instance.stars,
      'personalBest': instance.personalBest,
    };
