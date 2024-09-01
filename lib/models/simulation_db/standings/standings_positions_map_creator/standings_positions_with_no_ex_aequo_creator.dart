import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_creator.dart';

class StandingsPositionsWithNoExAequoCreator<S extends Score>
    extends StandingsPositionsCreator<S> {
  late List<S> _scores;

  @override
  Map<int, List<S>> create(List<S> scores) {
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

  Map<int, List<S>> _generatePositionsMap() {
    Map<int, List<S>> positionsMap = {};
    int currentPosition = 1;

    for (final score in _scores) {
      positionsMap[currentPosition] = [score];
      currentPosition++;
    }

    return positionsMap;
  }
}
