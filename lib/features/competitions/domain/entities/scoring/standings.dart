import 'package:collection/collection.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_creator.dart';

class Standings {
  Standings({
    required this.positionsCreator,
    List<Score>? initialScores,
  }) {
    _scores = initialScores ?? [];
    _scoresView = UnmodifiableListView(_scores);
  }

  late List<Score> _scores;
  late UnmodifiableListView<Score> _scoresView;
  late Map<int, List<Score>> _standings;

  final StandingsPositionsCreator positionsCreator;

  void add(Score score, {bool overwrite = false}) {
    final indexToChange =
        _scores.indexWhere((oldScore) => oldScore.subject == score.subject);
    if (indexToChange == -1) {
      _scores.add(score);
    } else if (overwrite) {
      _scores[indexToChange] = score;
    } else {
      throw StateError(
          'The score with entity (score: $score) is already contained in the standings, but the overwrite flag is set to false. Thus, the score cannot be added');
    }

    _update();
  }

  void remove(Score score) {
    _scores.remove(score);
    _update();
  }

  void _update() {
    _standings = positionsCreator.create(_scores);
  }

  List<Score>? get leaders => atPosition(1);

  List<Score>? atPosition(int position) => _standings[position];

  int? positionOf(dynamic subject) {
    int? toReturn;
    _standings.forEach((position, scores) {
      if (scores.any((score) => score.subject == subject)) {
        toReturn = position;
      }
    });
    return toReturn;
  }

  Score? scoreOf(dynamic subject) {
    return _scores.singleWhereOrNull((score) => score.subject == subject);
  }

  int get length => _scores.length;

  int get lastPosition {
    return _standings.keys.reduce((first, second) {
      if (second > first) {
        return second;
      } else {
        return first;
      }
    });
  }

  List<Score> get scores => _scoresView;
}
