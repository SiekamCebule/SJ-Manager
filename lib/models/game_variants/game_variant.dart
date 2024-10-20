import 'package:sj_manager/models/game_variants/game_variant_start_date.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_season.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_level_description.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class GameVariant {
  const GameVariant({
    required this.id,
    required this.name,
    required this.description,
    required this.jumpers,
    required this.hills,
    required this.countries,
    required this.countryTeams,
    required this.subteams,
    required this.season,
    required this.startDates,
    required this.actionDeadlines,
    required this.jumperLevelRequirements,
  });

  final String id;
  final MultilingualString name;
  final MultilingualString description;
  final List<Jumper> jumpers;
  final List<Hill> hills;
  final List<Country> countries;
  final List<CountryTeam> countryTeams;
  final List<Subteam> subteams;
  final SimulationSeason season;
  final List<GameVariantStartDate> startDates;
  final Map<SimulationActionType, DateTime> actionDeadlines;
  final Map<JumperLevelDescription, double> jumperLevelRequirements;

  GameVariant copyWith({
    String? id,
    MultilingualString? name,
    MultilingualString? description,
    List<Jumper>? jumpers,
    List<Hill>? hills,
    List<Country>? countries,
    List<CountryTeam>? countryTeams,
    List<Subteam>? subteams,
    SimulationSeason? season,
    List<GameVariantStartDate>? startDates,
    Map<SimulationActionType, DateTime>? actionDeadlines,
    Map<JumperLevelDescription, double>? jumperLevelRequirements,
  }) {
    return GameVariant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      jumpers: jumpers ?? List<Jumper>.from(this.jumpers),
      hills: hills ?? List<Hill>.from(this.hills),
      countries: countries ?? List<Country>.from(this.countries),
      countryTeams: countryTeams ?? List<CountryTeam>.from(this.countryTeams),
      subteams: subteams ?? List<Subteam>.from(this.subteams),
      season: season ?? this.season,
      startDates: startDates ?? List<GameVariantStartDate>.from(this.startDates),
      actionDeadlines: actionDeadlines ??
          Map<SimulationActionType, DateTime>.from(this.actionDeadlines),
      jumperLevelRequirements: jumperLevelRequirements ??
          Map<JumperLevelDescription, double>.from(this.jumperLevelRequirements),
    );
  }
}
