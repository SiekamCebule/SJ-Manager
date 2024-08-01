import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/models/db/event_series/standings/score/concrete/simple_points_score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_no_ex_aequo_creator.dart';

void main() {
  late StandingsPositionsCreator<SimplePointsScore<String>> creator;
  const recordsWithoutExAequo = [
    SimplePointsScore(140.5, entity: 'Maciej Kot'),
    SimplePointsScore(137.2, entity: 'Dawid Kubacki'),
    SimplePointsScore(132.5, entity: 'Kamil Stoch'),
    SimplePointsScore(130.4, entity: 'Jakub Wolny'),
    SimplePointsScore(128.5, entity: 'Paweł Wasek'),
    SimplePointsScore(111.5, entity: 'Andrzej Stękała'),
  ];

  const recordsWithExAequos = [
    SimplePointsScore(140.5, entity: 'Maciej Kot'),
    SimplePointsScore(140.5, entity: 'Dawid Kubacki'),
    SimplePointsScore(140.5, entity: 'Piotr Żyła'),
    SimplePointsScore(130.1, entity: 'Kamil Stoch'),
    SimplePointsScore(129.0, entity: 'Jakub Wolny'),
    SimplePointsScore(129.0, entity: 'Paweł Wasek'),
    SimplePointsScore(110.0, entity: 'Andrzej Stękała'),
    SimplePointsScore(110.0, entity: 'Kacper Tomasiak'),
    SimplePointsScore(107.6, entity: 'Stefan Hula'),
    SimplePointsScore(103.5, entity: 'Tymek Amilkiewicz'),
  ];

  group('When no aequos', () {
    const expected = {
      1: [SimplePointsScore(140.5, entity: 'Maciej Kot')],
      2: [SimplePointsScore(137.2, entity: 'Dawid Kubacki')],
      3: [SimplePointsScore(132.5, entity: 'Kamil Stoch')],
      4: [SimplePointsScore(130.4, entity: 'Jakub Wolny')],
      5: [SimplePointsScore(128.5, entity: 'Paweł Wasek')],
      6: [SimplePointsScore(111.5, entity: 'Andrzej Stękała')],
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
        1: [SimplePointsScore(140.5, entity: 'Maciej Kot')],
        2: [SimplePointsScore(140.5, entity: 'Dawid Kubacki')],
        3: [SimplePointsScore(140.5, entity: 'Piotr Żyła')],
        4: [SimplePointsScore(130.1, entity: 'Kamil Stoch')],
        5: [SimplePointsScore(129.0, entity: 'Jakub Wolny')],
        6: [SimplePointsScore(129.0, entity: 'Paweł Wasek')],
        7: [SimplePointsScore(110.0, entity: 'Andrzej Stękała')],
        8: [SimplePointsScore(110.0, entity: 'Kacper Tomasiak')],
        9: [SimplePointsScore(107.6, entity: 'Stefan Hula')],
        10: [SimplePointsScore(103.5, entity: 'Tymek Amilkiewicz')],
      });
    });
    test('Ex aequos for StandingsPositionsWithNoAequosCreator', () {
      creator = StandingsPositionsWithExAequosCreator();
      final positions = creator.create(recordsWithExAequos);
      expect(positions, const {
        1: [
          SimplePointsScore(140.5, entity: 'Maciej Kot'),
          SimplePointsScore(140.5, entity: 'Dawid Kubacki'),
          SimplePointsScore(140.5, entity: 'Piotr Żyła'),
        ],
        4: [
          SimplePointsScore(130.1, entity: 'Kamil Stoch'),
        ],
        5: [
          SimplePointsScore(129.0, entity: 'Jakub Wolny'),
          SimplePointsScore(129.0, entity: 'Paweł Wasek'),
        ],
        7: [
          SimplePointsScore(110.0, entity: 'Andrzej Stękała'),
          SimplePointsScore(110.0, entity: 'Kacper Tomasiak'),
        ],
        9: [SimplePointsScore(107.6, entity: 'Stefan Hula')],
        10: [SimplePointsScore(103.5, entity: 'Tymek Amilkiewicz')],
      });
    });
  });
}
