import 'package:sj_manager/models/database/country/country.dart';
import 'package:sj_manager/models/database/sex.dart';
import 'package:sj_manager/models/database/team/country_team/country_team_facts.dart';
import 'package:sj_manager/models/database/team/team.dart';

class CountryTeam extends Team {
  const CountryTeam({
    required this.sex,
    required this.country,
    required this.facts,
  });

  final Sex sex;
  final Country country;
  final CountryTeamFacts facts;

  @override
  List<Object?> get props => [
        facts,
        sex,
        country,
      ];

  CountryTeam copyWith({
    Sex? sex,
    Country? country,
    CountryTeamFacts? facts,
  }) {
    return CountryTeam(
      sex: sex ?? this.sex,
      country: country ?? this.country,
      facts: facts ?? this.facts,
    );
  }
}
