import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

abstract interface class StandingsPositionsCreator<S extends Score> {
  Map<int, List<S>> create(List<S> records);
}
