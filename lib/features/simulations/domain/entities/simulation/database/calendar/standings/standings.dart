import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/score.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings_positions_map_creator/standings_positions_creator.dart';

class Standings<E, D extends ScoreDetails> with EquatableMixin {
  Standings({required this.positionsCreator, List<Score<E, D>>? initialScores}) {
    if (initialScores != null) {
      _scores = List.of(initialScores);
      update();
    }
  }

  var _scores = <Score<E, D>>[];
  var _standings = <int, List<Score<E, D>>>{};
  final _subject = BehaviorSubject<Map<int, List<Score<E, D>>>>.seeded({});

  StandingsPositionsCreator<Score<E, D>> positionsCreator;

  void addScore({required Score<E, D> newScore, bool overwrite = false}) {
    Score<E, D>? scoreToChange;
    for (var score in _scores) {
      if (score.entity == newScore.entity) {
        scoreToChange = score;
      }
    }

    if (scoreToChange == null) {
      _scores.add(newScore);
    } else if (overwrite) {
      _scores[_scores.indexOf(scoreToChange)] = newScore;
    } else {
      throw StateError(
          'The score with entity (score: $newScore) is already contained in the standings, but the overwrite flag is set to false. Thus, the score cannot be added');
    }

    update();
  }

  void remove({required Score<E, D> score}) {
    _scores.remove(score);
    update();
  }

  void update() {
    _standings = positionsCreator.create(_scores);
  }

  List<Score<E, D>> get leaders {
    return atPosition(1);
  }

  List<Score<E, D>> atPosition(int position) {
    if (!_standings.containsKey(position)) {
      throw StateError('Standings does not have any entity at $position position');
    }
    return _standings[position]!;
  }

  int? positionOf(E entity) {
    for (var entry in _standings.entries) {
      bool hasScoreWithEntity =
          entry.value.where((score) => score.entity == entity).length == 1;
      if (hasScoreWithEntity) {
        return entry.key;
      }
    }
    return null;
  }

  Score<E, D>? scoreOf(E entity) {
    for (var score in _scores) {
      if (score.entity == entity) {
        return score;
      }
    }
    return null;
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

  bool containsEntity(E entity) {
    return _scores.where((score) => score.entity == entity).isNotEmpty;
  }

  List<Score<E, D>> get scores => _scores;

  void dispose() {
    _subject.close();
  }

  @override
  List<Object?> get props => [scores];
}
