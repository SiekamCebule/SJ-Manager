// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    required this.jumpers,
    required this.hills,
    required this.countries,
    required this.teams,
    required this.season,
  });

  final String id;
  final MultilingualString name;
  final List<Jumper> jumpers;
  final List<Hill> hills;
  final List<Country> countries;
  final List<Team> teams;
  final SimulationSeason season;

  GameVariant copyWith({
    String? id,
    MultilingualString? name,
    List<Jumper>? jumpers,
    List<Hill>? hills,
    List<Country>? countries,
    List<Team>? teams,
    SimulationSeason? season,
  }) {
    return GameVariant(
      id: id ?? this.id,
      name: name ?? this.name,
      jumpers: jumpers ?? this.jumpers,
      hills: hills ?? this.hills,
      countries: countries ?? this.countries,
      teams: teams ?? this.teams,
      season: season ?? this.season,
    );
  }
}
