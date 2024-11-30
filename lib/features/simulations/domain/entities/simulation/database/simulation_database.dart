import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/manager_data/simulation_manager_data.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
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
    required this.seasons,
    required this.idsRepository,
    required this.actions,
  });

  SimulationManagerData managerData;
  DateTime startDate;
  DateTime currentDate;
  Iterable<SimulationJumper> jumpers;
  Iterable<Hill> hills;
  CountriesRepository countries;
  Iterable<CountryTeam> countryTeams;
  Iterable<SimulationSeason> seasons;
  IdsRepository<String> idsRepository;
  Iterable<SimulationAction> actions;

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
        seasons,
        idsRepository,
        actions,
      ];
}
