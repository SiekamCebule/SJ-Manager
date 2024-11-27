import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/repository/country_teams_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class GetCountryTeamJumpersMapUseCase {
  GetCountryTeamJumpersMapUseCase({
    required this.countryTeamsRepository,
    required this.jumpersRepository,
  });

  final CountryTeamsRepository countryTeamsRepository;
  final SimulationJumpersRepository jumpersRepository;

  Future<Map<CountryTeam, Iterable<SimulationJumper>>> call() async {
    final jumpers = await jumpersRepository.getAll();
    final countryTeams = await countryTeamsRepository.getAll();
    return {
      for (var countryTeam in countryTeams)
        countryTeam: jumpers.where((jumper) => jumper.countryTeam == countryTeam)
    };
  }
}
