import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/manager_data/simulation_manager_data.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/simulation_season.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/team_reports.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
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
    required this.seasons,
    required this.idsRepository,
    required this.actions,
  });

  final SimulationManagerData managerData;

  final DateTime startDate;
  final DateTime currentDate;
  final Iterable<SimulationJumper> jumpers;
  final Iterable<Hill> hills;
  final CountriesRepository countries;
  final Iterable<CountryTeam> countryTeams;
  final Iterable<SimulationSeason> seasons;
  final IdsRepository<String> idsRepository;
  final Iterable<SimulationAction> actions;

  SimulationDatabaseModel copyWith({
    SimulationManagerData? managerData,
    DateTime? startDate,
    DateTime? currentDate,
    Iterable<SimulationJumper>? jumpers,
    Iterable<Hill>? hills,
    CountriesRepository? countries,
    Iterable<CountryTeam>? countryTeams,
    Map<Subteam, Iterable<String>>? subteamJumpers,
    Iterable<SimulationSeason>? seasons,
    IdsRepository<String>? idsRepository,
    Iterable<SimulationAction>? actions,
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
      seasons: seasons ?? this.seasons,
      idsRepository: idsRepository ?? this.idsRepository,
      actions: actions ?? this.actions,
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
        seasons,
        idsRepository,
        actions,
      ];
}
