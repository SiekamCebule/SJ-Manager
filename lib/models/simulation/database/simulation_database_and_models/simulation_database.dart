import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_actions_repo.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_manager_data.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/models/simulation/jumper/stats/jumper_stats.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/models/database/hill/hill.dart';
import 'package:sj_manager/models/database/sex.dart';
import 'package:sj_manager/models/database/team/country_team/country_team.dart';
import 'package:sj_manager/models/database/team/subteam.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class SimulationDatabase with EquatableMixin, ChangeNotifier {
  SimulationDatabase({
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
    required this.jumperReports,
    required this.jumperStats,
    required this.teamReports,
  });

  SimulationManagerData managerData;

  DateTime startDate;
  DateTime currentDate;
  List<SimulationJumper> jumpers;
  List<Hill> hills;
  CountriesRepo countries;
  List<CountryTeam> countryTeams;
  List<SimulationSeason> seasons;
  ItemsIdsRepo<String> idsRepo;

  Map<SimulationActionType, DateTime> actionDeadlines;
  SimulationActionsRepo actionsRepo;

  Map<String, JumperReports> jumperReports;
  Map<String, JumperStats> jumperStats;
  Map<String, TeamReports> teamReports;
  Map<Subteam, Iterable<String>> subteamJumpers;

  void notify() => notifyListeners();

  Iterable<SimulationJumper> get maleJumpers =>
      jumpers.where((jumper) => jumper.sex == Sex.male);
  Iterable<SimulationJumper> get femaleJumpers =>
      jumpers.where((jumper) => jumper.sex == Sex.female);
  Iterable<CountryTeam> get maleJumperTeams =>
      countryTeams.where((team) => team.sex == Sex.male).cast();
  Iterable<CountryTeam> get femaleJumperTeams =>
      countryTeams.where((team) => team.sex == Sex.female).cast();

  SimulationDatabase copyWith({
    SimulationManagerData? managerData,
    DateTime? startDate,
    DateTime? currentDate,
    List<SimulationJumper>? jumpers,
    List<Hill>? hills,
    CountriesRepo? countries,
    List<CountryTeam>? countryTeams,
    Map<Subteam, Iterable<String>>? subteamJumpers,
    List<SimulationSeason>? seasons,
    ItemsIdsRepo<String>? idsRepo,
    Map<SimulationActionType, DateTime>? actionDeadlines,
    SimulationActionsRepo? actionsRepo,
    Map<String, JumperReports>? jumperReports,
    Map<String, JumperStats>? jumperStats,
    Map<String, TeamReports>? teamReports,
  }) {
    return SimulationDatabase(
      managerData: managerData ?? this.managerData,
      startDate: startDate ?? this.startDate,
      currentDate: currentDate ?? this.currentDate,
      jumpers: jumpers ?? this.jumpers,
      hills: hills ?? this.hills,
      countries: countries ?? this.countries,
      countryTeams: countryTeams ?? this.countryTeams,
      subteamJumpers: subteamJumpers ?? this.subteamJumpers,
      seasons: seasons ?? this.seasons,
      idsRepo: idsRepo ?? this.idsRepo,
      actionDeadlines: actionDeadlines ?? this.actionDeadlines,
      actionsRepo: actionsRepo ?? this.actionsRepo,
      jumperReports: jumperReports ?? this.jumperReports,
      jumperStats: jumperStats ?? this.jumperStats,
      teamReports: teamReports ?? this.teamReports,
    );
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
        jumperReports,
        jumperStats,
        teamReports
      ];
}
