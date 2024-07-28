import 'package:sj_manager/models/db/event_series/standings/standings_record.dart';

abstract interface class StandingsPositionsCreator<T extends StandingsRecord> {
  Map<int, List<T>> create(List<T> records);
}
