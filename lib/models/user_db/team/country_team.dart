import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/country/team_facts.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class CountryTeam extends Team {
  const CountryTeam({
    required super.facts,
    required this.sex,
    required this.country,
  });

  final Sex sex;
  final Country country;

  CountryTeam copyWith({
    TeamFacts? facts,
    Sex? sex,
    Country? country,
  }) {
    return CountryTeam(
      facts: facts ?? this.facts,
      sex: sex ?? this.sex,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [facts, sex, country];

  factory CountryTeam.fromJson(Json json, {required JsonCountryLoader countryLoader}) {
    return CountryTeam(
      facts: TeamFacts.fromJson(json['facts'] as Map<String, dynamic>),
      sex: $enumDecode(_sexEnumMap, json['sex']),
      country: countryLoader.load(json['country']),
    );
  }

  Json toJson({required JsonCountrySaver countrySaver}) {
    return {
      'facts': facts.toJson(),
      'sex': _sexEnumMap[sex]!,
      'country': countrySaver.save(country),
    };
  }
}

const _sexEnumMap = {
  Sex.male: 'male',
  Sex.female: 'female',
};
