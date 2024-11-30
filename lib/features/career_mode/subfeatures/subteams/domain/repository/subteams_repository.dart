import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

abstract interface class SubteamsRepository {
  Future<Iterable<Subteam>> getAll();
  Future<Iterable<Subteam>> getByCountry(CountryTeam countryTeam);
  Future<void> setCountrySubteams(
      {required CountryTeam countryTeam, required Iterable<Subteam> subteams});
  Future<void> setSubteam({required Subteam subteam});
}
