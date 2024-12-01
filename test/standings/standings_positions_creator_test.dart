import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/score_details.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_no_ex_aequo_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/score.dart';

void main() {
  late StandingsPositionsCreator creator;
  const recordsWithoutExAequo = [
    Score<String, SimplePointsScoreDetails>(
      points: 140.5,
      entity: 'Maciej Kot',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 137.2,
      entity: 'Dawid Kubacki',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 132.5,
      entity: 'Kamil Stoch',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 130.4,
      entity: 'Jakub Wolny',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 128.5,
      entity: 'Paweł Wasek',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 111.5,
      entity: 'Andrzej Stękała',
      details: SimplePointsScoreDetails(),
    ),
  ];

  const recordsWithExAequos = [
    Score<String, SimplePointsScoreDetails>(
      points: 140.5,
      entity: 'Maciej Kot',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 140.5,
      entity: 'Dawid Kubacki',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 140.5,
      entity: 'Piotr Żyła',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 130.1,
      entity: 'Kamil Stoch',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 129.0,
      entity: 'Jakub Wolny',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 129.0,
      entity: 'Paweł Wasek',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 110.0,
      entity: 'Andrzej Stękała',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 110.0,
      entity: 'Kacper Tomasiak',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 107.6,
      entity: 'Stefan Hula',
      details: SimplePointsScoreDetails(),
    ),
    Score<String, SimplePointsScoreDetails>(
      points: 103.5,
      entity: 'Tymek Amilkiewicz',
      details: SimplePointsScoreDetails(),
    ),
  ];

  group('When no aequos', () {
    const expected = {
      1: [
        Score<String, SimplePointsScoreDetails>(
          points: 140.5,
          entity: 'Maciej Kot',
          details: SimplePointsScoreDetails(),
        )
      ],
      2: [
        Score<String, SimplePointsScoreDetails>(
          points: 137.2,
          entity: 'Dawid Kubacki',
          details: SimplePointsScoreDetails(),
        )
      ],
      3: [
        Score<String, SimplePointsScoreDetails>(
          points: 132.5,
          entity: 'Kamil Stoch',
          details: SimplePointsScoreDetails(),
        )
      ],
      4: [
        Score<String, SimplePointsScoreDetails>(
          points: 130.4,
          entity: 'Jakub Wolny',
          details: SimplePointsScoreDetails(),
        )
      ],
      5: [
        Score<String, SimplePointsScoreDetails>(
          points: 128.5,
          entity: 'Paweł Wasek',
          details: SimplePointsScoreDetails(),
        )
      ],
      6: [
        Score<String, SimplePointsScoreDetails>(
          points: 111.5,
          entity: 'Andrzej Stękała',
          details: SimplePointsScoreDetails(),
        )
      ],
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
        1: [
          Score<String, SimplePointsScoreDetails>(
            points: 140.5,
            entity: 'Maciej Kot',
            details: SimplePointsScoreDetails(),
          )
        ],
        2: [
          Score<String, SimplePointsScoreDetails>(
            points: 140.5,
            entity: 'Dawid Kubacki',
            details: SimplePointsScoreDetails(),
          )
        ],
        3: [
          Score<String, SimplePointsScoreDetails>(
            points: 140.5,
            entity: 'Piotr Żyła',
            details: SimplePointsScoreDetails(),
          )
        ],
        4: [
          Score<String, SimplePointsScoreDetails>(
            points: 130.1,
            entity: 'Kamil Stoch',
            details: SimplePointsScoreDetails(),
          )
        ],
        5: [
          Score<String, SimplePointsScoreDetails>(
            points: 129.0,
            entity: 'Jakub Wolny',
            details: SimplePointsScoreDetails(),
          )
        ],
        6: [
          Score<String, SimplePointsScoreDetails>(
            points: 129.0,
            entity: 'Paweł Wasek',
            details: SimplePointsScoreDetails(),
          )
        ],
        7: [
          Score<String, SimplePointsScoreDetails>(
            points: 110.0,
            entity: 'Andrzej Stękała',
            details: SimplePointsScoreDetails(),
          )
        ],
        8: [
          Score<String, SimplePointsScoreDetails>(
            points: 110.0,
            entity: 'Kacper Tomasiak',
            details: SimplePointsScoreDetails(),
          )
        ],
        9: [
          Score<String, SimplePointsScoreDetails>(
            points: 107.6,
            entity: 'Stefan Hula',
            details: SimplePointsScoreDetails(),
          )
        ],
        10: [
          Score<String, SimplePointsScoreDetails>(
            points: 103.5,
            entity: 'Tymek Amilkiewicz',
            details: SimplePointsScoreDetails(),
          )
        ],
      });
    });
    test('Ex aequos for StandingsPositionsWithExAequosCreator', () {
      creator = StandingsPositionsWithExAequosCreator();
      final positions = creator.create(recordsWithExAequos);
      expect(positions, const {
        1: [
          Score<String, SimplePointsScoreDetails>(
            points: 140.5,
            entity: 'Maciej Kot',
            details: SimplePointsScoreDetails(),
          ),
          Score<String, SimplePointsScoreDetails>(
            points: 140.5,
            entity: 'Dawid Kubacki',
            details: SimplePointsScoreDetails(),
          ),
          Score<String, SimplePointsScoreDetails>(
            points: 140.5,
            entity: 'Piotr Żyła',
            details: SimplePointsScoreDetails(),
          ),
        ],
        4: [
          Score<String, SimplePointsScoreDetails>(
            points: 130.1,
            entity: 'Kamil Stoch',
            details: SimplePointsScoreDetails(),
          ),
        ],
        5: [
          Score<String, SimplePointsScoreDetails>(
            points: 129.0,
            entity: 'Jakub Wolny',
            details: SimplePointsScoreDetails(),
          ),
          Score<String, SimplePointsScoreDetails>(
            points: 129.0,
            entity: 'Paweł Wasek',
            details: SimplePointsScoreDetails(),
          ),
        ],
        7: [
          Score<String, SimplePointsScoreDetails>(
            points: 110.0,
            entity: 'Andrzej Stękała',
            details: SimplePointsScoreDetails(),
          ),
          Score<String, SimplePointsScoreDetails>(
            points: 110.0,
            entity: 'Kacper Tomasiak',
            details: SimplePointsScoreDetails(),
          ),
        ],
        9: [
          Score<String, SimplePointsScoreDetails>(
            points: 107.6,
            entity: 'Stefan Hula',
            details: SimplePointsScoreDetails(),
          ),
        ],
        10: [
          Score<String, SimplePointsScoreDetails>(
            points: 103.5,
            entity: 'Tymek Amilkiewicz',
            details: SimplePointsScoreDetails(),
          ),
        ],
      });
    });
  });
}
