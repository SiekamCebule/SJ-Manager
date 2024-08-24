import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';

class StandingsPositionsWithExAequosCreator extends StandingsPositionsCreator {
  late List<Score> _scores;

  @override
  Map<int, List<Score>> create(List<Score> scores) {
    _scores = List.of(scores);
    _sortScores();
    return _generatePositionsMap();
  }

  void _sortScores() {
    _scores.sort((a, b) {
      if (a > b) return -1;
      if (a < b) return 1;
      return 0; // Maintain original order if scores are equal
    });
  }

  Map<int, List<Score>> _generatePositionsMap() {
    Map<int, List<Score>> positionsMap = {};
    int currentPosition = 1;
    int currentRank = 1;

    for (int i = 0; i < _scores.length; i++) {
      if (i > 0 && _scores[i] != _scores[i - 1]) {
        currentRank = currentPosition;
      }

      positionsMap.putIfAbsent(currentRank, () => []).add(_scores[i]);
      currentPosition++;
    }

    return positionsMap;
  }
}
