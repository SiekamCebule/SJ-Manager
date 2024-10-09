// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sj_manager/models/simulation/database/helper/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';

class SimulationDatabaseHelper {
  const SimulationDatabaseHelper({
    required this.userSubteam,
    required this.jumpersDynamicParameters,
  });

  final Subteam? userSubteam;

  final Map<Jumper, JumperSimulationRatings> jumpersDynamicParameters;
}

class JumperSimulationRatings {
  const JumperSimulationRatings({
    required this.levelDescription,
    required this.moraleRating,
    required this.resultsRating,
    required this.trainingRating,
  });

  final JumperLevelDescription levelDescription;
  final SimpleRating moraleRating;
  final SimpleRating resultsRating;
  final SimpleRating trainingRating;

  JumperSimulationRatings copyWith({
    JumperLevelDescription? levelDescription,
    SimpleRating? moraleRating,
    SimpleRating? resultsRating,
    SimpleRating? trainingRating,
  }) {
    return JumperSimulationRatings(
      levelDescription: levelDescription ?? this.levelDescription,
      moraleRating: moraleRating ?? this.moraleRating,
      resultsRating: resultsRating ?? this.resultsRating,
      trainingRating: trainingRating ?? this.trainingRating,
    );
  }
}
