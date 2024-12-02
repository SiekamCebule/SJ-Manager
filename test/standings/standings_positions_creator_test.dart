import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/test_scores.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_no_ex_aequo_creator.dart';

void main() {
  late StandingsPositionsCreator creator;
  const scoresWithoutExAequo = [
    SimpleScore(subject: 'Maciej Kot', points: 140.5),
    SimpleScore(subject: 'Dawid Kubacki', points: 137.2),
    SimpleScore(subject: 'Kamil Stoch', points: 132.5),
    SimpleScore(subject: 'Jakub Wolny', points: 130.4),
    SimpleScore(subject: 'Paweł Wasek', points: 128.5),
    SimpleScore(subject: 'Andrzej Stękała', points: 111.5),
  ];

  const scoresWithExAequo = [
    SimpleScore(subject: 'Maciej Kot', points: 140.5),
    SimpleScore(subject: 'Dawid Kubacki', points: 140.5),
    SimpleScore(subject: 'Piotr Żyła', points: 140.5),
    SimpleScore(subject: 'Kamil Stoch', points: 130.1),
    SimpleScore(subject: 'Jakub Wolny', points: 129.0),
    SimpleScore(subject: 'Paweł Wasek', points: 129.0),
    SimpleScore(subject: 'Andrzej Stękała', points: 110.0),
    SimpleScore(subject: 'Kacper Tomasiak', points: 110.0),
    SimpleScore(subject: 'Stefan Hula', points: 107.6),
    SimpleScore(subject: 'Tymek Amilkiewicz', points: 103.5),
  ];

  group('When no aequos', () {
    const expected = {
      1: [SimpleScore(subject: 'Maciej Kot', points: 140.5)],
      2: [SimpleScore(subject: 'Dawid Kubacki', points: 137.2)],
      3: [SimpleScore(subject: 'Kamil Stoch', points: 132.5)],
      4: [SimpleScore(subject: 'Jakub Wolny', points: 130.4)],
      5: [SimpleScore(subject: 'Paweł Wasek', points: 128.5)],
      6: [SimpleScore(subject: 'Andrzej Stękała', points: 111.5)],
    };

    test('No ex aequos for StandingsPositionsWithNoExAequoCreator', () {
      creator = StandingsPositionsWithNoExAequoCreator();
      final positions = creator.create(scoresWithoutExAequo.cast());
      expect(positions, expected);
    });

    test('No ex aequos for StandingsPositionsWithExAequosCreator', () {
      creator = StandingsPositionsWithExAequosCreator();
      final positions = creator.create(scoresWithoutExAequo.cast());
      expect(positions, expected);
    });
  });

  group('When there are ex aequos', () {
    test('Ex aequos for StandingsPositionsWithNoExAequoCreator', () {
      creator = StandingsPositionsWithNoExAequoCreator();
      final positions = creator.create(scoresWithExAequo.cast());
      expect(positions, const {
        1: [SimpleScore(subject: 'Maciej Kot', points: 140.5)],
        2: [SimpleScore(subject: 'Dawid Kubacki', points: 140.5)],
        3: [SimpleScore(subject: 'Piotr Żyła', points: 140.5)],
        4: [SimpleScore(subject: 'Kamil Stoch', points: 130.1)],
        5: [SimpleScore(subject: 'Jakub Wolny', points: 129.0)],
        6: [SimpleScore(subject: 'Paweł Wasek', points: 129.0)],
        7: [SimpleScore(subject: 'Andrzej Stękała', points: 110.0)],
        8: [SimpleScore(subject: 'Kacper Tomasiak', points: 110.0)],
        9: [SimpleScore(subject: 'Stefan Hula', points: 107.6)],
        10: [SimpleScore(subject: 'Tymek Amilkiewicz', points: 103.5)],
      });
    });

    test('Ex aequos for StandingsPositionsWithExAequosCreator', () {
      creator = StandingsPositionsWithExAequosCreator();
      final positions = creator.create(scoresWithExAequo.cast());
      expect(positions, const {
        1: [
          SimpleScore(subject: 'Maciej Kot', points: 140.5),
          SimpleScore(subject: 'Dawid Kubacki', points: 140.5),
          SimpleScore(subject: 'Piotr Żyła', points: 140.5),
        ],
        4: [SimpleScore(subject: 'Kamil Stoch', points: 130.1)],
        5: [
          SimpleScore(subject: 'Jakub Wolny', points: 129.0),
          SimpleScore(subject: 'Paweł Wasek', points: 129.0),
        ],
        7: [
          SimpleScore(subject: 'Andrzej Stękała', points: 110.0),
          SimpleScore(subject: 'Kacper Tomasiak', points: 110.0),
        ],
        9: [SimpleScore(subject: 'Stefan Hula', points: 107.6)],
        10: [SimpleScore(subject: 'Tymek Amilkiewicz', points: 103.5)],
      });
    });
  });
}
