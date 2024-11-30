import 'package:collection/collection.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/repository/subteams_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

class GetAllCountrySubteamsUseCase {
  GetAllCountrySubteamsUseCase({
    required this.subteamsRepository,
  });

  final SubteamsRepository subteamsRepository;

  Future<Iterable<Subteam>> call(CountryTeam countryTeam) async {
    return (await subteamsRepository.getByCountry(countryTeam))
        .sorted((a, b) => a.type.index.compareTo(b.type.index));
  }
}
