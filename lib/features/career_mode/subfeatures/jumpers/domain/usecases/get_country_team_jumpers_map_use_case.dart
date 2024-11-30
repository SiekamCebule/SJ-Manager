import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/repository/country_teams_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

class GetCountryTeamJumpersMapUseCase {
  GetCountryTeamJumpersMapUseCase({
    required this.countryTeamsRepository,
  });

  final CountryTeamsRepository countryTeamsRepository;

  Future<Map<CountryTeam, Iterable<SimulationJumper>>> call() async {
    final countryTeams = await countryTeamsRepository.getAll();
    return {
      for (var countryTeam in countryTeams) countryTeam: countryTeam.jumpers,
    };
  }
}
