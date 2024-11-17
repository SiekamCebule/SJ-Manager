import 'dart:math';

import 'package:sj_manager/domain/entities/simulation/standings/score/score.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings_positions_map_creator/standings_positions_creator.dart';

class StandingsPositionsWithShuffleOnEqualPositionsCreator<S extends Score>
    extends StandingsPositionsCreator<S> {
  final Random _random = Random();

  @override
  void generatePositionsMap() {
    int currentPosition = 1;
    int currentRank = 1;

    for (int i = 0; i < scores.length; i++) {
      if (i > 0 && scores[i] < scores[i - 1]) {
        currentRank = currentPosition;
      }

      positionsMap.putIfAbsent(currentRank, () => []).add(scores[i]);
      currentPosition++;
    }
    _shuffleScoresWithSamePositions();
  }

  void _shuffleScoresWithSamePositions() {
    for (var position in positionsMap.keys) {
      positionsMap[position]!.shuffle(_random);
    }
  }
}
