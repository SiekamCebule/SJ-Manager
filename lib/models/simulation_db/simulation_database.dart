import 'package:sj_manager/models/simulation_db/enums.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class SimulationDatabase {
  const SimulationDatabase({
    required this.mode,
    required this.jumpers,
    required this.hills,
    required this.teams,
    required this.countries,
    required this.seasons,
    required this.idsRepo,
  });

  final SimulationMode mode;
  final ItemsRepo<Jumper> jumpers;
  final ItemsRepo<Hill> hills;
  final CountriesRepo countries;
  final TeamsRepo teams;
  final ItemsRepo<SimulationSeason> seasons;
  final ItemsIdsRepo idsRepo;

  Iterable<MaleJumper> get maleJumpers => jumpers.last.whereType<MaleJumper>();
  Iterable<FemaleJumper> get femaleJumpers => jumpers.last.whereType<FemaleJumper>();
  Iterable<CountryTeam> get maleJumperTeams =>
      teams.last.where((team) => (team as CountryTeam).sex == Sex.male).cast();
  Iterable<CountryTeam> get femaleJumperTeams =>
      teams.last.where((team) => (team as CountryTeam).sex == Sex.female).cast();

  void dispose() {
    jumpers.dispose();
    hills.dispose();
    countries.dispose();
    teams.dispose();
    seasons.dispose();
  }
}
