import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team_facts_db_record.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/core/general_utils/json/countries.dart';

class CountryTeamDbRecord extends Equatable {
  const CountryTeamDbRecord({
    required this.sex,
    required this.country,
    required this.facts,
  });

  final Sex sex;
  final Country country;
  final CountryTeamFactsDbRecord facts;

  Future<Map<String, dynamic>> toJson({
    required JsonCountrySaver countrySerializer,
  }) async {
    return {
      'sex': sex.name,
      'country': countrySerializer.save(country),
      'facts': facts.toJson(),
    };
  }

  static Future<CountryTeamDbRecord> fromJson(
    Map<String, dynamic> json, {
    required JsonCountryLoader countryLoader,
  }) async {
    return CountryTeamDbRecord(
      sex: Sex.values.firstWhere((e) => e.toString() == json['sex']),
      country: await countryLoader.load(json['country']),
      facts: CountryTeamFactsDbRecord.fromJson(json['facts'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [
        facts,
        sex,
        country,
      ];

  CountryTeamDbRecord copyWith({
    Sex? sex,
    Country? country,
    CountryTeamFactsDbRecord? facts,
  }) {
    return CountryTeamDbRecord(
      sex: sex ?? this.sex,
      country: country ?? this.country,
      facts: facts ?? this.facts,
    );
  }
}
