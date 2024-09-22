import 'package:sj_manager/models/game_variants/game_variant_start_date.dart';
import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class GameVariant {
  const GameVariant({
    required this.id,
    required this.name,
    required this.description,
    required this.jumpers,
    required this.hills,
    required this.countries,
    required this.teams,
    required this.season,
    required this.startDates,
  });

  final String id;
  final MultilingualString name;
  final MultilingualString description;
  final List<Jumper> jumpers;
  final List<Hill> hills;
  final List<Country> countries;
  final List<Team> teams;
  final SimulationSeason season;
  final List<GameVariantStartDate> startDates;

  GameVariant copyWith({
    String? id,
    MultilingualString? name,
    MultilingualString? description,
    List<Jumper>? jumpers,
    List<Hill>? hills,
    List<Country>? countries,
    List<Team>? teams,
    SimulationSeason? season,
    List<GameVariantStartDate>? startDates,
  }) {
    return GameVariant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      jumpers: jumpers ?? this.jumpers,
      hills: hills ?? this.hills,
      countries: countries ?? this.countries,
      teams: teams ?? this.teams,
      season: season ?? this.season,
      startDates: startDates ?? this.startDates,
    );
  }
}
