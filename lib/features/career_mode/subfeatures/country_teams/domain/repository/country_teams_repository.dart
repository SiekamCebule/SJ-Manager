import 'package:sj_manager/core/core_classes/country_team/country_team.dart';

abstract interface class CountryTeamsRepository {
  Future<Iterable<CountryTeam>> getAll();
  Future<void> add(CountryTeam team);
  Future<void> remove(CountryTeam team);
}
