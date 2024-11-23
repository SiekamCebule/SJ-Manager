import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';

import 'package:sj_manager/features/simulations/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/actions/simulation_actions_repo.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/manager_data/simulation_manager_data.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/reports/team_reports.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/subteam.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class SimulationDatabaseModel with EquatableMixin {
  const SimulationDatabaseModel({
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
    required this.actionDeadlines,
    required this.actionsRepo,
    required this.teamReports,
  });

  final SimulationManagerData managerData;

  final DateTime startDate;
  final DateTime currentDate;
  final List<SimulationJumper> jumpers;
  final List<Hill> hills;
  final CountriesRepository countries;
  final List<CountryTeam> countryTeams;
  final List<SimulationSeason> seasons;
  final IdsRepository<String> idsRepository;

  final Map<SimulationActionType, DateTime> actionDeadlines;
  final SimulationActionsRepo actionsRepo;

  final Map<String, TeamReports> teamReports;
  final Map<Subteam, Iterable<String>> subteamJumpers;

  Iterable<SimulationJumper> get maleJumpers =>
      jumpers.where((jumper) => jumper.sex == Sex.male);
  Iterable<SimulationJumper> get femaleJumpers =>
      jumpers.where((jumper) => jumper.sex == Sex.female);
  Iterable<CountryTeam> get maleJumperTeams =>
      countryTeams.where((team) => team.sex == Sex.male).cast();
  Iterable<CountryTeam> get femaleJumperTeams =>
      countryTeams.where((team) => team.sex == Sex.female).cast();

  SimulationDatabaseModel copyWith({
    SimulationManagerData? managerData,
    DateTime? startDate,
    DateTime? currentDate,
    List<SimulationJumper>? jumpers,
    List<Hill>? hills,
    CountriesRepository? countries,
    List<CountryTeam>? countryTeams,
    Map<Subteam, Iterable<String>>? subteamJumpers,
    List<SimulationSeason>? seasons,
    IdsRepository<String>? idsRepository,
    Map<SimulationActionType, DateTime>? actionDeadlines,
    SimulationActionsRepo? actionsRepo,
    Map<String, TeamReports>? teamReports,
  }) {
    return SimulationDatabaseModel(
      managerData: managerData ?? this.managerData,
      startDate: startDate ?? this.startDate,
      currentDate: currentDate ?? this.currentDate,
      jumpers: jumpers ?? this.jumpers,
      hills: hills ?? this.hills,
      countries: countries ?? this.countries,
      countryTeams: countryTeams ?? this.countryTeams,
      subteamJumpers: subteamJumpers ?? this.subteamJumpers,
      seasons: seasons ?? this.seasons,
      idsRepository: idsRepository ?? this.idsRepository,
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
        idsRepository,
        actionDeadlines,
        actionsRepo,
        teamReports
      ];
}
