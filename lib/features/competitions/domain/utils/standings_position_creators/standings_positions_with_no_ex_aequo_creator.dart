import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_creator.dart';

class StandingsPositionsWithNoExAequoCreator extends StandingsPositionsCreator {
  @override
  void generatePositionsMap() {
    int currentPosition = 1;
    for (final score in scores) {
      positionsMap[currentPosition] = [score];
      currentPosition++;
    }
  }
}
