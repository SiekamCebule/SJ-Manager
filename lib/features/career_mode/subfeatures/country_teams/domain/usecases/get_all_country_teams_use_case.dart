import 'package:sj_manager/features/career_mode/subfeatures/country_teams/domain/repository/country_teams_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

class GetAllCountryTeamsUseCase {
  GetAllCountryTeamsUseCase({
    required this.countryTeamsRepository,
  });

  final CountryTeamsRepository countryTeamsRepository;

  Future<Iterable<CountryTeam>> call() async {
    return await countryTeamsRepository.getAll();
  }
}
