import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/countries/country_facts/teams_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class SimulationDatabase {
  const SimulationDatabase({
    required this.jumpers,
    required this.hills,
    required this.teams,
    required this.countries,
    required this.seasons,
    required this.idsRepo,
  });

  final ItemsRepo<Jumper> jumpers;
  final ItemsRepo<Hill> hills;
  final CountriesRepo countries;
  final TeamsRepo teams;
  final ItemsRepo<SimulationSeason> seasons;
  final ItemsIdsRepo idsRepo;
}
