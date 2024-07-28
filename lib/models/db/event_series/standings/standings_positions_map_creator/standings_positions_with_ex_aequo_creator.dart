import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_record.dart';

class StandingsPositionsWithExAequoCreator<T extends StandingsRecord>
    implements StandingsPositionsCreator<T> {
  @override
  Map<int, List<T>> create(List<T> records) {
    _sortRecords(records);
    return _generatePositionsMap(records);
  }

  void _sortRecords(List<T> records) {
    records.sort((a, b) => b.compareTo(a));
  }

  Map<int, List<T>> _generatePositionsMap(List<T> records) {
    Map<int, List<T>> positionsMap = {};
    int currentPosition = 1;
    int currentRank = 1;

    for (int i = 0; i < records.length; i++) {
      if (i > 0 && records[i].score != records[i - 1].score) {
        currentRank = currentPosition;
      }

      positionsMap.putIfAbsent(currentRank, () => []).add(records[i]);
      currentPosition++;
    }

    return positionsMap;
  }
}
