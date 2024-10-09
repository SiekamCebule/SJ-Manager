import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation/database/simulation_season.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class SimulationDatabase with EquatableMixin {
  const SimulationDatabase({
    required this.userSubteam,
    required this.personalCoachJumpers,
    required this.startDate,
    required this.currentDate,
    required this.jumpers,
    required this.hills,
    required this.countries,
    required this.countryTeams,
    required this.subteams,
    required this.seasons,
    required this.idsRepo,
  });

  final Subteam? userSubteam;
  final List<Jumper>? personalCoachJumpers;
  final DateTime startDate;
  final DateTime currentDate;
  final ItemsRepo<Jumper> jumpers;
  final ItemsRepo<Hill> hills;
  final CountriesRepo countries;
  final ItemsRepo<CountryTeam> countryTeams;
  final ItemsRepo<Subteam> subteams;
  final ItemsRepo<SimulationSeason> seasons;
  final ItemsIdsRepo idsRepo;

  Iterable<MaleJumper> get maleJumpers => jumpers.last.whereType<MaleJumper>();
  Iterable<FemaleJumper> get femaleJumpers => jumpers.last.whereType<FemaleJumper>();
  Iterable<CountryTeam> get maleJumperTeams =>
      countryTeams.last.where((team) => team.sex == Sex.male).cast();
  Iterable<CountryTeam> get femaleJumperTeams =>
      countryTeams.last.where((team) => team.sex == Sex.female).cast();

  void dispose() {
    jumpers.dispose();
    hills.dispose();
    countries.dispose();
    countryTeams.dispose();
    seasons.dispose();
  }

  @override
  List<Object?> get props => [
        userSubteam,
        personalCoachJumpers,
        startDate,
        currentDate,
        jumpers,
        hills,
        countries,
        countryTeams,
        subteams,
        seasons,
        idsRepo,
      ];
}
