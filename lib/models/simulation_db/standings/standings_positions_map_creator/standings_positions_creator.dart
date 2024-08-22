import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

abstract interface class StandingsPositionsCreator {
  Map<int, List<Score>> create(List<Score> records);
}
