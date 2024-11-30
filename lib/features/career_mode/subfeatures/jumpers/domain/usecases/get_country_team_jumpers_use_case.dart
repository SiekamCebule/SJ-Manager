import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

class GetCountryTeamJumpersUseCase {
  GetCountryTeamJumpersUseCase({
    required this.jumpersRepository,
  });

  final SimulationJumpersRepository jumpersRepository;

  Future<Iterable<SimulationJumper>> call(CountryTeam countryTeam) async {
    final jumpers = await jumpersRepository.getAll();
    return jumpers.where((jumper) => jumper.countryTeam == countryTeam);
  }
}
