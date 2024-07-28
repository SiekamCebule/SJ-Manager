import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_record.dart';
import 'package:sj_manager/repositories/generic/value_repo.dart';

class StandingsRepo<E, S extends Score, R extends StandingsRecord<E, S>>
    implements ValueRepo<Map<int, List<R>>> {
  StandingsRepo({required this.positionsCreator, List<R>? initialRecords}) {
    if (initialRecords != null) {
      _records = initialRecords;
      _updateStandings();
      set(_standings);
    }
  }

  var _records = <R>[];
  var _standings = <int, List<R>>{};
  final _subject = BehaviorSubject<Map<int, List<R>>>.seeded({});

  final StandingsPositionsCreator<R> positionsCreator;

  void update({required R newRecord}) {
    R? recordToChange;
    for (var record in _records) {
      if (record.entity == newRecord.entity) {
        recordToChange = record;
      }
    }

    if (recordToChange != null) {
      throw StateError('Standings does not have the entiy (${newRecord.entity})');
    }

    _records[_records.indexOf(recordToChange!)] = newRecord;

    _updateStandings();
    set(_standings);
  }

  void _updateStandings() {
    _standings = positionsCreator.create(_records);
  }

  List<R> atPosition(int position) {
    if (!_standings.containsKey(position)) {
      throw StateError('Standings does not have any entity at $position position');
    }
    return _standings[position]!;
  }

  int positionOf(E entity) {
    int? toReturn;
    _standings.forEach((position, entities) {
      if (entities.contains(entity)) {
        toReturn = position;
      }
    });
    if (toReturn == null) {
      throw StateError('The entity ($entity) is not contained by standings');
    }
    return toReturn!;
  }

  S? scoreOf(E entity) {
    for (var record in _records) {
      if (record.entity == entity) {
        return record.score;
      }
    }
    return null;
  }

  int get length => last.length;

  bool containsEntity(E entity) {
    return _records.where((record) => record.entity == entity).isNotEmpty;
  }

  @override
  void set(Map<int, List<R>> value) {
    _subject.add(Map.of(value));
  }

  @override
  ValueStream<Map<int, List<R>>> get items => _subject.stream;

  @override
  Map<int, List<R>> get last => items.value;

  @override
  void dispose() {
    _subject.close();
  }
}
