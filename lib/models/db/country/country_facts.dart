import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/jumps/simple_jump_record.dart';

part 'country_facts.g.dart';

@JsonSerializable()
class CountryFacts {
  const CountryFacts({
    required this.countryCode,
    required this.stars,
    required this.personalBest,
  });

  MaleCountryFacts toMale() => MaleCountryFacts(
      countryCode: countryCode, stars: stars, personalBest: personalBest);
  FemaleCountryFacts toFemale() => FemaleCountryFacts(
      countryCode: countryCode, stars: stars, personalBest: personalBest);

  final String countryCode;
  final int stars;
  final SimpleJumpRecord personalBest;

  static CountryFacts fromJson(Json json) => _$CountryFactsFromJson(json);

  Json toJson() => _$CountryFactsToJson(this);
}

class MaleCountryFacts extends CountryFacts {
  const MaleCountryFacts({
    required super.countryCode,
    required super.stars,
    required super.personalBest,
  });

  static MaleCountryFacts fromJson(Json json) => _$CountryFactsFromJson(json).toMale();
}

class FemaleCountryFacts extends CountryFacts {
  const FemaleCountryFacts({
    required super.countryCode,
    required super.stars,
    required super.personalBest,
  });
  static FemaleCountryFacts fromJson(Json json) =>
      _$CountryFactsFromJson(json).toFemale();
}
