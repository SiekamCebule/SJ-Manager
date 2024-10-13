import 'package:sj_manager/models/simulation/flow/simple_rating.dart';
import 'package:sj_manager/models/simulation/flow/training/reports.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';

class SimulationDatabaseHelper {
  const SimulationDatabaseHelper({
    required this.userSubteam,
    required this.managerPoints,
    required this.jumpersSimulationRatings,
  });

  final Subteam? userSubteam;

  final int managerPoints;
  final Map<Jumper, JumperSimulationRatings> jumpersSimulationRatings;
}

class JumperSimulationRatings {
  const JumperSimulationRatings({
    required this.levelReport,
    required this.trainingProgressReport,
    required this.moraleRating,
    required this.resultsRating,
  });

  final JumperLevelReport levelReport;
  final JumperTrainingProgressReport trainingProgressReport;
  final SimpleRating moraleRating;
  final SimpleRating resultsRating;

  JumperSimulationRatings copyWith({
    JumperLevelReport? levelReport,
    JumperTrainingProgressReport? trainingProgressReport,
    SimpleRating? moraleRating,
    SimpleRating? resultsRating,
  }) {
    return JumperSimulationRatings(
      levelReport: levelReport ?? this.levelReport,
      trainingProgressReport: trainingProgressReport ?? this.trainingProgressReport,
      moraleRating: moraleRating ?? this.moraleRating,
      resultsRating: resultsRating ?? this.resultsRating,
    );
  }
}
