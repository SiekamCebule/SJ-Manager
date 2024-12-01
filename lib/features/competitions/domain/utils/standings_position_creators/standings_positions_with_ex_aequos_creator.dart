import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_creator.dart';

class StandingsPositionsWithExAequosCreator extends StandingsPositionsCreator {
  @override
  void generatePositionsMap() {
    int currentPosition = 1;
    int currentRank = 1;

    while (currentPosition <= scores.length) {
      final tiedScores = <Score>[];
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
