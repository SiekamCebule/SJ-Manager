import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';

import 'package:sj_manager/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/domain/entities/simulation/database/actions/simulation_actions_repo.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_manager_data.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/stats/jumper_stats.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/domain/entities/simulation/flow/reports/team_reports.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';
import 'package:sj_manager/features/game_variants/data/models/game_variant_database.dart/sex.dart';
import 'package:sj_manager/core/classes/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

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
    required this.teamReports,
  });

  SimulationManagerData managerData;

  DateTime startDate;
  DateTime currentDate;
  List<SimulationJumper> jumpers;
  List<Hill> hills;
  CountriesRepository countries;
  List<CountryTeam> countryTeams;
  List<SimulationSeason> seasons;
  ItemsIdsRepo<String> idsRepo;

  Map<SimulationActionType, DateTime> actionDeadlines;
  SimulationActionsRepo actionsRepo;

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
    CountriesRepository? countries,
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
        teamReports
      ];
}
