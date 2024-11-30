import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/repository/country_teams_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/repository/subteams_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

class GetSubteamsByCountryTeamMapUseCase {
  GetSubteamsByCountryTeamMapUseCase({
    required this.subteamsRepository,
    required this.countryTeamsRepository,
  });

  final SubteamsRepository subteamsRepository;
  final CountryTeamsRepository countryTeamsRepository;

  Future<Map<CountryTeam, Iterable<Subteam>>> call() async {
    final countryTeams = await countryTeamsRepository.getAll();
    return {
      for (final countryTeam in countryTeams)
        countryTeam: await subteamsRepository.getByCountry(countryTeam),
    };
  }
}
