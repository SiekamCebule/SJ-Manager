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

    while (currentPosition <= _scores.length) {
      List<Score> tiedScores = [];
      double currentPoints = _scores[currentPosition - 1].points;

      while (currentPosition <= _scores.length &&
          _scores[currentPosition - 1].points == currentPoints) {
        tiedScores.add(_scores[currentPosition - 1]);
        currentPosition++;
      }

      positionsMap[currentRank] = tiedScores;
      currentRank += tiedScores.length;
    }

    return positionsMap;
  }
}
