import 'package:sj_manager/models/db/event_series/standings/score/score.dart';

abstract interface class StandingsPositionsCreator<S extends Score> {
  Map<int, List<S>> create(List<S> records);
}
