import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/models/db/event_series/standings/score/basic_score_types.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_no_ex_aequo_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_record.dart';

void main() {
  late StandingsPositionsCreator<StandingsRecord<String, SimplePointsScore>> creator;
  const recordsWithoutExAequo = [
    StandingsRecord(entity: 'Maciej Kot', score: SimplePointsScore(140.5)),
    StandingsRecord(entity: 'Dawid Kubacki', score: SimplePointsScore(137.2)),
    StandingsRecord(entity: 'Kamil Stoch', score: SimplePointsScore(132.5)),
    StandingsRecord(entity: 'Jakub Wolny', score: SimplePointsScore(130.4)),
    StandingsRecord(entity: 'Paweł Wasek', score: SimplePointsScore(128.5)),
    StandingsRecord(entity: 'Andrzej Stękała', score: SimplePointsScore(111.5)),
  ];

  const recordsWithExAequos = [
    StandingsRecord(entity: 'Maciej Kot', score: SimplePointsScore(140.5)),
    StandingsRecord(entity: 'Dawid Kubacki', score: SimplePointsScore(140.5)),
    StandingsRecord(entity: 'Piotr Żyła', score: SimplePointsScore(140.5)),
    StandingsRecord(entity: 'Kamil Stoch', score: SimplePointsScore(130.1)),
    StandingsRecord(entity: 'Jakub Wolny', score: SimplePointsScore(129.0)),
    StandingsRecord(entity: 'Paweł Wasek', score: SimplePointsScore(129.0)),
    StandingsRecord(entity: 'Andrzej Stękała', score: SimplePointsScore(110.0)),
    StandingsRecord(entity: 'Kacper Tomasiak', score: SimplePointsScore(110.0)),
    StandingsRecord(entity: 'Stefan Hula', score: SimplePointsScore(107.6)),
    StandingsRecord(entity: 'Tymek Amilkiewicz', score: SimplePointsScore(103.5)),
  ];

  group('When no aequos', () {
    const expected = {
      1: [StandingsRecord(entity: 'Maciej Kot', score: SimplePointsScore(140.5))],
      2: [StandingsRecord(entity: 'Dawid Kubacki', score: SimplePointsScore(137.2))],
      3: [StandingsRecord(entity: 'Kamil Stoch', score: SimplePointsScore(132.5))],
      4: [StandingsRecord(entity: 'Jakub Wolny', score: SimplePointsScore(130.4))],
      5: [StandingsRecord(entity: 'Paweł Wasek', score: SimplePointsScore(128.5))],
      6: [StandingsRecord(entity: 'Andrzej Stękała', score: SimplePointsScore(111.5))],
    };
    test('No ex aequos for StandingsPositionsWithNoExAequoCreator', () {
      creator = StandingsPositionsWithNoExAequoCreator();
      final positions = creator.create(recordsWithoutExAequo);
      expect(positions, expected);
    });
    test('No ex aequos for StandingsPositionsWithExAequosCreator', () {
      creator = StandingsPositionsWithExAequosCreator();
      final positions = creator.create(recordsWithoutExAequo);
      expect(positions, expected);
    });
  });

  group('When there are ex aequos', () {
    test('Ex aequos for StandingsPositionsWithNoExAequoCreator', () {
      creator = StandingsPositionsWithNoExAequoCreator();
      final positions = creator.create(recordsWithExAequos);
      expect(positions, const {
        1: [StandingsRecord(entity: 'Maciej Kot', score: SimplePointsScore(140.5))],
        2: [StandingsRecord(entity: 'Dawid Kubacki', score: SimplePointsScore(140.5))],
        3: [StandingsRecord(entity: 'Piotr Żyła', score: SimplePointsScore(140.5))],
        4: [StandingsRecord(entity: 'Kamil Stoch', score: SimplePointsScore(130.1))],
        5: [StandingsRecord(entity: 'Jakub Wolny', score: SimplePointsScore(129.0))],
        6: [StandingsRecord(entity: 'Paweł Wasek', score: SimplePointsScore(129.0))],
        7: [StandingsRecord(entity: 'Andrzej Stękała', score: SimplePointsScore(110.0))],
        8: [StandingsRecord(entity: 'Kacper Tomasiak', score: SimplePointsScore(110.0))],
        9: [StandingsRecord(entity: 'Stefan Hula', score: SimplePointsScore(107.6))],
        10: [
          StandingsRecord(entity: 'Tymek Amilkiewicz', score: SimplePointsScore(103.5))
        ],
      });
    });
    test('Ex aequos for StandingsPositionsWithNoAequosCreator', () {
      creator = StandingsPositionsWithExAequosCreator();
      final positions = creator.create(recordsWithExAequos);
      expect(positions, const {
        1: [
          StandingsRecord(entity: 'Maciej Kot', score: SimplePointsScore(140.5)),
          StandingsRecord(entity: 'Dawid Kubacki', score: SimplePointsScore(140.5)),
          StandingsRecord(entity: 'Piotr Żyła', score: SimplePointsScore(140.5)),
        ],
        4: [
          StandingsRecord(entity: 'Kamil Stoch', score: SimplePointsScore(130.1)),
        ],
        5: [
          StandingsRecord(entity: 'Jakub Wolny', score: SimplePointsScore(129.0)),
          StandingsRecord(entity: 'Paweł Wasek', score: SimplePointsScore(129.0)),
        ],
        7: [
          StandingsRecord(entity: 'Andrzej Stękała', score: SimplePointsScore(110.0)),
          StandingsRecord(entity: 'Kacper Tomasiak', score: SimplePointsScore(110.0)),
        ],
        9: [StandingsRecord(entity: 'Stefan Hula', score: SimplePointsScore(107.6))],
        10: [
          StandingsRecord(entity: 'Tymek Amilkiewicz', score: SimplePointsScore(103.5))
        ],
      });
    });
  });
}
