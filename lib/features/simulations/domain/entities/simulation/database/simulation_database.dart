import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/manager_data/simulation_manager_data.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/reports/team_reports.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

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
    required this.idsRepository,
    required this.actions,
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
  IdsRepository<String> idsRepository;

  List<SimulationAction> actions;

  Map<String, TeamReports> teamReports;
  Map<Subteam, Iterable<String>> subteamJumpers;

  void notify() => notifyListeners();

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
        idsRepository,
        actions,
        teamReports
      ];
}
