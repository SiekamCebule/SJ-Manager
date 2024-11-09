import 'package:equatable/equatable.dart';

import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_actions_repo.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_manager_data.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/models/simulation/flow/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/jumper_stats/jumper_stats.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/sex.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class SimulationDatabase with EquatableMixin {
  const SimulationDatabase({
    required this.managerData,
    required this.startDate,
    required this.currentDate,
    required this.jumpers,
    required this.hills,
    required this.countries,
    required this.countryTeams,
    required this.subteamJumpers,
    required this.seasons,
    required this.idsRepo,
    required this.actionDeadlines,
    required this.actionsRepo,
    required this.jumperDynamicParams,
    required this.jumperReports,
    required this.jumperStats,
    required this.teamReports,
  });

  final SimulationManagerData managerData;

  final DateTime startDate;
  final DateTime currentDate;
  final ItemsRepo<Jumper> jumpers;
  final ItemsRepo<Hill> hills;
  final CountriesRepo countries;
  final ItemsRepo<CountryTeam> countryTeams;
  final ItemsRepo<SimulationSeason> seasons;
  final ItemsIdsRepo idsRepo;

  final Map<SimulationActionType, DateTime> actionDeadlines;
  final SimulationActionsRepo actionsRepo;

  final Map<Jumper, JumperDynamicParams> jumperDynamicParams;
  final Map<Jumper, JumperReports> jumperReports;
  final Map<Jumper, JumperStats> jumperStats;

  final Map<Team, TeamReports> teamReports;

  final Map<Subteam, Iterable<String>> subteamJumpers;

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
        managerData,
        startDate,
        currentDate,
        jumpers,
        hills,
        countries,
        countryTeams,
        subteamJumpers,
        seasons,
        idsRepo,
        actionDeadlines,
        actionsRepo,
        jumperDynamicParams,
        jumperReports,
        jumperStats,
        teamReports
      ];

  SimulationDatabase copyWith({
    SimulationManagerData? managerData,
    DateTime? startDate,
    DateTime? currentDate,
    ItemsRepo<Jumper>? jumpers,
    ItemsRepo<Hill>? hills,
    CountriesRepo? countries,
    ItemsRepo<CountryTeam>? countryTeams,
    ItemsRepo<SimulationSeason>? seasons,
    ItemsIdsRepo? idsRepo,
    Map<SimulationActionType, DateTime>? actionDeadlines,
    SimulationActionsRepo? actionsRepo,
    Map<Jumper, JumperDynamicParams>? jumperDynamicParams,
    Map<Jumper, JumperReports>? jumperReports,
    Map<Jumper, JumperStats>? jumperStats,
    Map<Team, TeamReports>? teamReports,
    Map<Subteam, Iterable<String>>? subteamJumpers,
  }) {
    return SimulationDatabase(
      managerData: managerData ?? this.managerData,
      startDate: startDate ?? this.startDate,
      currentDate: currentDate ?? this.currentDate,
      jumpers: jumpers ?? this.jumpers,
      hills: hills ?? this.hills,
      countries: countries ?? this.countries,
      countryTeams: countryTeams ?? this.countryTeams,
      seasons: seasons ?? this.seasons,
      idsRepo: idsRepo ?? this.idsRepo,
      actionDeadlines: actionDeadlines ?? this.actionDeadlines,
      actionsRepo: actionsRepo ?? this.actionsRepo,
      jumperDynamicParams: jumperDynamicParams ?? this.jumperDynamicParams,
      jumperReports: jumperReports ?? this.jumperReports,
      jumperStats: jumperStats ?? this.jumperStats,
      teamReports: teamReports ?? this.teamReports,
      subteamJumpers: subteamJumpers ?? this.subteamJumpers,
    );
  }
}
