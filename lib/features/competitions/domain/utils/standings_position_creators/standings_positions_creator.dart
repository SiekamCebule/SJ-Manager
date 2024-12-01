import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';

abstract class StandingsPositionsCreator with EquatableMixin {
  late List<Score> scores;
  late Map<int, List<Score>> positionsMap;

  Map<int, List<Score>> create(List<Score> scores) {
    setUp();
    this.scores = List.of(scores);
    sortScoresDescending();
    generatePositionsMap();
    return positionsMap;
  }

  void setUp() {
    scores = [];
    positionsMap = {};
  }

  void sortScoresDescending() {
    scores.sort((a, b) {
      if (a > b) return -1;
      if (a < b) return 1;
      return 0;
    });
  }

  void generatePositionsMap();

  @override
  List<Object?> get props => [
        runtimeType,
      ];
}
