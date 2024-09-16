import 'package:sj_manager/models/simulation_db/simulation_season.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class GameVariant {
  const GameVariant({
    required this.id,
    required this.name,
    required this.jumpers,
    required this.hills,
    required this.season,
  });

  final String id;
  final MultilingualString name;
  final List<Jumper> jumpers;
  final List<Hill> hills;
  final SimulationSeason season;
}
