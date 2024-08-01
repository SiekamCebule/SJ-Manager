import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';

class StandingsRepo<E> implements ValueRepo<Map<int, List<Score<E>>>> {
  StandingsRepo({required this.positionsCreator, List<Score<E>>? initialScores}) {
    if (initialScores != null) {
      _scores = List.of(initialScores);
      update();
      set(_standings);
    }
  }

  var _scores = <Score<E>>[];
  var _standings = <int, List<Score<E>>>{};
  final _subject = BehaviorSubject<Map<int, List<Score<E>>>>.seeded({});

  StandingsPositionsCreator<Score<E>> positionsCreator;

  void addScore({required Score<E> newScore, bool overwrite = false}) {
    Score<E>? scoreToChange;
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
          'The score $newScore is already contained in the standings, but the overwrite flag is set to false. Thus, the score cannot be added');
    }

    update();
    set(_standings);
  }

  void remove({required Score<E> score}) {
    _scores.remove(score);
    update();
    set(_standings);
  }

  void update() {
    _standings = positionsCreator.create(_scores);
  }

  List<Score<E>> get leaders {
    return atPosition(1);
  }

  List<Score<E>> atPosition(int position) {
    if (!_standings.containsKey(position)) {
      throw StateError('Standings does not have any entity at $position position');
    }
    return _standings[position]!;
  }

  int positionOf(E entity) {
    for (var entry in _standings.entries) {
      bool hasScoreWithEntity =
          entry.value.where((score) => score.entity == entity).length == 1;
      if (hasScoreWithEntity) {
        return entry.key;
      }
    }
    throw _notContainEntityError(entity);
  }

  Score<E> scoreOf(E entity) {
    for (var score in _scores) {
      if (score.entity == entity) {
        return score;
      }
    }
    throw _notContainEntityError(entity);
  }

  Error _notContainEntityError(E entity) {
    return StateError('The entity ($entity) is not contained by standings');
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

  @override
  void set(Map<int, List<Score<E>>> value) {
    _subject.add(Map.of(value));
  }

  @override
  ValueStream<Map<int, List<Score<E>>>> get items => _subject.stream;

  @override
  Map<int, List<Score<E>>> get last => items.value;

  @override
  void dispose() {
    _subject.close();
  }
}
