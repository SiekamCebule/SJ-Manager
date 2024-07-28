import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_record.dart';

class StandingsPositionsWithNoExAequoCreator<T extends StandingsRecord>
    implements StandingsPositionsCreator<T> {
  late List<T> _records;

  @override
  Map<int, List<T>> create(List<T> records) {
    _records = List.of(records);
    _sortRecords();
    return _generatePositionsMap();
  }

  void _sortRecords() {
    _records.sort((a, b) {
      if (a.score > b.score) return -1;
      if (a.score < b.score) return 1;
      return 0; // Maintain original order if scores are equal
    });
  }

  Map<int, List<T>> _generatePositionsMap() {
    Map<int, List<T>> positionsMap = {};
    int currentPosition = 1;

    for (T record in _records) {
      positionsMap[currentPosition] = [record];
      currentPosition++;
    }

    return positionsMap;
  }
}
