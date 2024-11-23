import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team_facts_model.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';

class CountryTeam extends Team {
  const CountryTeam({
    required this.sex,
    required this.country,
    required this.facts,
  });

  final Sex sex;
  final Country country;
  final CountryTeamFactsModel facts;

  @override
  List<Object?> get props => [
        facts,
        sex,
        country,
      ];

  CountryTeam copyWith({
    Sex? sex,
    Country? country,
    CountryTeamFactsModel? facts,
  }) {
    return CountryTeam(
      sex: sex ?? this.sex,
      country: country ?? this.country,
      facts: facts ?? this.facts,
    );
  }
}
