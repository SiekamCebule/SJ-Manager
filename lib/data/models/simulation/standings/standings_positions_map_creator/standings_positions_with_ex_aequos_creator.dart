import 'package:sj_manager/data/models/simulation/standings/score/score.dart';
import 'package:sj_manager/data/models/simulation/standings/standings_positions_map_creator/standings_positions_creator.dart';

class StandingsPositionsWithExAequosCreator<S extends Score>
    extends StandingsPositionsCreator<S> {
  @override
  void generatePositionsMap() {
    int currentPosition = 1;
    int currentRank = 1;

    while (currentPosition <= scores.length) {
      List<S> tiedScores = [];
      double currentPoints = scores[currentPosition - 1].points;

      while (currentPosition <= scores.length &&
          scores[currentPosition - 1].points == currentPoints) {
        tiedScores.add(scores[currentPosition - 1]);
        currentPosition++;
      }

      positionsMap[currentRank] = tiedScores;
      currentRank += tiedScores.length;
    }
  }
}
