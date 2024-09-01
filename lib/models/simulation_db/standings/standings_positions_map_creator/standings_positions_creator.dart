import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';

abstract class StandingsPositionsCreator<S extends Score> with EquatableMixin {
  late List<S> scores;
  late Map<int, List<S>> positionsMap;

  Map<int, List<S>> create(List<S> scores) {
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
