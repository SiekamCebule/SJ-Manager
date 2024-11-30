import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';

abstract interface class CountryTeamsRepository {
  Future<Iterable<CountryTeam>> getAll();
  Future<void> add(CountryTeam team);
  Future<void> remove(CountryTeam team);
}
