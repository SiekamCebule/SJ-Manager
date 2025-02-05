import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/test_scores.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/context/ko_groups_creator_context.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/context/ko_round_advancemenent_determinating_context.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/competition/rules/entities_limit.dart';
import 'package:sj_manager/to_embrace/competition/rules/ko/ko_group.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default_random.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_group_creator.dart/concrete/default_with_pots.dart';
import 'package:sj_manager/features/competitions/domain/utils/ko_round_advancement_determinator/concrete/n_best.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_no_ex_aequo_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_shuffle_on_equal_positions_creator.dart';

import 'ko_competition_utilities_test.mocks.dart';

@GenerateMocks([
  KoGroupsCreatingContext,
  ClassicKoGroupsCreatingContext,
  RandomKoGroupsCreatingContext,
  KoGroupsPotsCreatingContext,
  KoRoundNBestAdvancementDeterminingContext,
  SimulationJumper,
])
void main() {
  SimulationJumper createJumper(String name, String surname) {
    final jumper = MockSimulationJumper();
    when(jumper.name).thenReturn(name);
    when(jumper.surname).thenReturn(surname);
    return jumper;
  }

  group('KoGroupsCreator', () {
    group('DefaultClassicKoGroupsCreator', () {
      test(
          'Creates groups for 8 jumpers in good order (groups\'s order and the order wihin group). Checks if passing uneven number causes an error',
          () {
        final context = MockClassicKoGroupsCreatingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Dawid', 'Kubacki'),
          createJumper('Piotr', 'Żyła'),
          createJumper('David', 'Siegel'),
          createJumper('Tymoteusz', 'Amilkiewicz'),
          createJumper('Yevhen', 'Marusiak'),
          createJumper('Evgeniy', 'Klimov'),
          createJumper('Robert', 'Johansson'),
        ];
        final creator = DefaultClassicKoGroupsCreator<SimulationJumper>();
        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        expect(
          () {
            creator.create(context);
          },
          throwsA(isA<ArgumentError>()),
        );
        jumpers.add(
          createJumper('Halvor Egner', 'Granerud'),
        );
        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        final groups = creator.create(context);
        expect(groups, [
          KoGroup(entities: [jumpers[4], jumpers[3]]),
          KoGroup(entities: [jumpers[5], jumpers[2]]),
          KoGroup(entities: [jumpers[6], jumpers[1]]),
          KoGroup(entities: [jumpers[7], jumpers[0]]),
        ]);
      });
    });

    group('DefaultRandomKoGroupsCreator', () {
      test('Even groups', () {
        final context = MockRandomKoGroupsCreatingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Jumper 1', ''),
          createJumper('Jumper 2', ''),
          createJumper('Jumper 3', ''),
          createJumper('Jumper 4', ''),
          createJumper('Jumper 5', ''),
          createJumper('Jumper 6', ''),
          createJumper('Jumper 7', ''),
          createJumper('Jumper 8', ''),
          createJumper('Jumper 9', ''),
        ];
        final creator = DefaultRandomKoGroupsCreator<SimulationJumper>();

        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        when(context.entitiesInGroup).thenReturn(3);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.throwError);

        final groups = creator.create(context);

        expect(groups.length, 3);
        expect(groups.every((group) => group.entities.length == 3), isTrue);
        expect(groups.expand((group) => group.entities).toSet().length,
            jumpers.length); // no duplicates
      });

      test('Uneven groups, remainingEntitiesAction - placeInSmallestGroup', () {
        final context = MockRandomKoGroupsCreatingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Jumper 1', ''),
          createJumper('Jumper 2', ''),
          createJumper('Jumper 3', ''),
          createJumper('Jumper 4', ''),
          createJumper('Jumper 5', ''),
          createJumper('Jumper 6', ''),
          createJumper('Jumper 7', ''),
          createJumper('Jumper 8', ''),
          createJumper('Jumper 9', ''),
          createJumper('Jumper 10', ''),
        ];
        final creator = DefaultRandomKoGroupsCreator<SimulationJumper>();

        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeInSmallestGroup);

        final groups = creator.create(context);

        expect(groups.length, 2);
        expect(groups.where((group) => group.entities.length == 5).length, 2);
        expect(groups.expand((group) => group.entities).toSet().length,
            jumpers.length); // no duplicates
      });

      test('Uneven groups, remainingEntitiesAction - placeRandomly', () {
        final context = MockRandomKoGroupsCreatingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Jumper 1', ''),
          createJumper('Jumper 2', ''),
          createJumper('Jumper 3', ''),
          createJumper('Jumper 4', ''),
          createJumper('Jumper 5', ''),
          createJumper('Jumper 6', ''),
          createJumper('Jumper 7', ''),
          createJumper('Jumper 8', ''),
          createJumper('Jumper 9', ''),
          createJumper('Jumper 10', ''),
          createJumper('Jumper 11', ''),
        ];
        final creator = DefaultRandomKoGroupsCreator<SimulationJumper>();

        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeRandomly);

        final groups = creator.create(context);

        expect(groups.length, 2);
        expect(groups.where((group) => group.entities.length == 5).length, 1);
        expect(groups.where((group) => group.entities.length == 6).length, 1);
        expect(groups.expand((group) => group.entities).toSet().length,
            jumpers.length); // no duplicates
      });

      test('Uneven groups, remainingEntitiesAction - placeAtBegin', () {
        final context = MockRandomKoGroupsCreatingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Jumper 1', ''),
          createJumper('Jumper 2', ''),
          createJumper('Jumper 3', ''),
          createJumper('Jumper 4', ''),
          createJumper('Jumper 5', ''),
          createJumper('Jumper 6', ''),
          createJumper('Jumper 7', ''),
          createJumper('Jumper 8', ''),
          createJumper('Jumper 9', ''),
        ];
        final creator = DefaultRandomKoGroupsCreator<SimulationJumper>();

        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeAtBegin);

        final groups = creator.create(context);
        expect(groups.length, 2);
        expect(groups.first.entities.length, 5);
        expect(groups[1].entities.length, 4);
        expect(groups.expand((group) => group.entities).toSet().length,
            jumpers.length); // no duplicates
      });
    });

    group('DefaultPotsKoGroupsCreator', () {
      test('Typical scenario', () {
        final context = MockKoGroupsPotsCreatingContext();
        final pots = [
          [
            createJumper('Jumper 1', ''),
            createJumper('Jumper 2', ''),
            createJumper('Jumper 3', ''),
          ],
          [
            createJumper('Jumper 4', ''),
            createJumper('Jumper 5', ''),
            createJumper('Jumper 6', ''),
          ],
          [
            createJumper('Jumper 7', ''),
            createJumper('Jumper 8', ''),
            createJumper('Jumper 9', ''),
          ],
          [
            createJumper('Jumper 10', ''),
            createJumper('Jumper 11', ''),
            createJumper('Jumper 12', ''),
          ],
        ];
        final creator = DefaultPotsKoGroupsCreator();

        when(context.pots).thenReturn(pots);
        when(context.entitiesCount)
            .thenReturn(pots.expand((entities) => entities).length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.throwError);

        final groups = creator.create(context);
        expect(groups.length, 3);
        expect(groups.every((group) => group.entities.length == 4), isTrue);
        expect(groups.map((group) => group.entities.first), containsAll(pots[0]));
      });
      test('Uneven groups, remainingEntitiesAction - placeRandomly', () {
        final context = MockKoGroupsPotsCreatingContext();
        final additionalJumper = createJumper('Jumper 3.5', '');
        final pots = [
          [
            createJumper('Jumper 1', ''),
            createJumper('Jumper 2', ''),
            createJumper('Jumper 3', ''),
            additionalJumper,
          ],
          [
            createJumper('Jumper 4', ''),
            createJumper('Jumper 5', ''),
            createJumper('Jumper 6', ''),
          ],
          [
            createJumper('Jumper 7', ''),
            createJumper('Jumper 8', ''),
            createJumper('Jumper 9', ''),
          ],
          [
            createJumper('Jumper 10', ''),
            createJumper('Jumper 11', ''),
            createJumper('Jumper 12', ''),
          ],
        ];
        final creator = DefaultPotsKoGroupsCreator();
        when(context.pots).thenReturn(pots);
        when(context.entitiesCount)
            .thenReturn(pots.expand((entities) => entities).length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeRandomly);

        final groups = creator.create(context);
        expect(groups.length, 3);
        expect(groups.where((group) => group.entities.length == 4).length, 2);
        expect(groups.where((group) => group.entities.length == 5).length, 1);
        final firstEntities = groups.map((group) => group.entities[0]);
        final secondEntities = groups.map((group) => group.entities[1]);
        expect(
          firstEntities.contains(additionalJumper) ||
              secondEntities.contains(additionalJumper),
          true,
        );
      });

      test('Overwhelming entities count in first group', () {
        final context = MockKoGroupsPotsCreatingContext();
        final pots = [
          [
            createJumper('Jumper 1', ''),
            createJumper('Jumper 2', ''),
            createJumper('Jumper 3', ''),
            createJumper('Jumper 4', ''),
            createJumper('Jumper 5', ''),
            createJumper('Jumper 6', ''),
          ],
          [
            createJumper('Jumper 7', ''),
            createJumper('Jumper 8', ''),
            createJumper('Jumper 9', ''),
          ],
          [
            createJumper('Jumper 10', ''),
            createJumper('Jumper 11', ''),
            createJumper('Jumper 12', ''),
          ],
          [
            createJumper('Jumper 13', ''),
            createJumper('Jumper 14', ''),
            createJumper('Jumper 15', ''),
          ],
        ];
        final creator = DefaultPotsKoGroupsCreator();
        when(context.pots).thenReturn(pots);
        when(context.entitiesCount)
            .thenReturn(pots.expand((entities) => entities).length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeRandomly);

        final groups = creator.create(context);
        expect(groups.length, 3);
        expect(groups.expand((group) => group.entities).length, 15);
      });

      test('Additional pot with one entity', () {
        final context = MockKoGroupsPotsCreatingContext();
        final pots = [
          [
            createJumper('Jumper 1', ''),
            createJumper('Jumper 2', ''),
            createJumper('Jumper 3', ''),
          ],
          [
            createJumper('Jumper 4', ''),
            createJumper('Jumper 5', ''),
            createJumper('Jumper 6', ''),
          ],
          [
            createJumper('Jumper 7', ''),
            createJumper('Jumper 8', ''),
            createJumper('Jumper 9', ''),
          ],
          [
            createJumper('Jumper 10', ''),
            createJumper('Jumper 11', ''),
            createJumper('Jumper 12', ''),
          ],
          [
            createJumper('Jumper 13', ''),
          ],
        ];
        final creator = DefaultPotsKoGroupsCreator();
        when(context.pots).thenReturn(pots);
        when(context.entitiesCount)
            .thenReturn(pots.expand((entities) => entities).length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeRandomly);

        final groups = creator.create(context);
        expect(groups.length, 3);
        expect(groups.where((group) => group.entities.length == 4).length, 2);
        expect(groups.where((group) => group.entities.length == 5).length, 1);
      });
    });
  });

  group('KoRoundAdvancementDeterminator', () {
    group('NBestKoRoundAdvancementDeterminator', () {
      test('Typical without ex aequo conflicts', () {
        const determinator = NBestKoRoundAdvancementDeterminator<SimulationJumper>();
        final context = MockKoRoundNBestAdvancementDeterminingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Kamil', 'Stoch'),
          createJumper('Giovanni', 'Bresadola'),
          createJumper('Martin', 'Hamann'),
        ];
        final standings = Standings(
          positionsCreator: StandingsPositionsWithExAequosCreator(),
          initialScores: <SimpleScore>[
            SimpleScore(
              subject: jumpers[0],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[1],
              points: 134.5,
            ),
            SimpleScore(
              subject: jumpers[2],
              points: 105.4,
            ),
          ],
        );
        provideDummy(standings);
        when(context.entities).thenReturn(jumpers);
        when(context.limit).thenReturn(const EntitiesLimit.exact(1));
        when(context.koStandings).thenReturn(
          standings,
        );
        final advanced = determinator.determineAdvancement(context);
        expect(advanced, [jumpers[1]]);
      });

      test('Ex aequo on first place, but limit is exact(1)', () {
        const determinator = NBestKoRoundAdvancementDeterminator<SimulationJumper>();
        final context = MockKoRoundNBestAdvancementDeterminingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Kamil', 'Stoch'),
          createJumper('Giovanni', 'Bresadola'),
          createJumper('Martin', 'Hamann'),
        ];
        final standings = Standings(
          positionsCreator: StandingsPositionsWithExAequosCreator(),
          initialScores: [
            SimpleScore(subject: jumpers[0], points: 127.7),
            SimpleScore(subject: jumpers[1], points: 127.7),
            SimpleScore(subject: jumpers[2], points: 105.4),
          ],
        );
        provideDummy(standings);
        when(context.entities).thenReturn(jumpers);
        when(context.limit).thenReturn(const EntitiesLimit.exact(1));
        when(context.koStandings).thenReturn(
          standings,
        );
        final advanced = determinator.determineAdvancement(context);
        expect(advanced.length, 1);
      });

      test('No ex aequos, but same points count', () {
        const determinator = NBestKoRoundAdvancementDeterminator<SimulationJumper>();
        final context = MockKoRoundNBestAdvancementDeterminingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Kamil', 'Stoch'),
          createJumper('Giovanni', 'Bresadola'),
          createJumper('Martin', 'Hamann'),
        ];
        final standings = Standings(
          positionsCreator: StandingsPositionsWithNoExAequoCreator(),
          initialScores: [
            SimpleScore(
              subject: jumpers[0],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[1],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[2],
              points: 105.4,
            ),
          ],
        );
        provideDummy(standings);
        when(context.entities).thenReturn(jumpers);
        when(context.limit).thenReturn(const EntitiesLimit.exact(1));
        when(context.koStandings).thenReturn(
          standings,
        );
        final advanced = determinator.determineAdvancement(context);
        expect(advanced, [jumpers[0]]);
      });

      test('Shuffle on same points count', () {
        const determinator = NBestKoRoundAdvancementDeterminator<SimulationJumper>();
        final context = MockKoRoundNBestAdvancementDeterminingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Kamil', 'Stoch'),
          createJumper('Giovanni', 'Bresadola'),
          createJumper('Martin', 'Hamann'),
        ];
        final standings = Standings(
          positionsCreator: StandingsPositionsWithShuffleOnEqualPositionsCreator(),
          initialScores: [
            SimpleScore(
              subject: jumpers[0],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[1],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[2],
              points: 105.4,
            ),
          ],
        );
        provideDummy(standings);
        when(context.entities).thenReturn(jumpers);
        when(context.limit).thenReturn(const EntitiesLimit.exact(1));
        when(context.koStandings).thenReturn(
          standings,
        );
        final advanced = determinator.determineAdvancement(context);
        expect(advanced.length, 1);
      });

      test('Soft limit + ex aequo', () {
        const determinator = NBestKoRoundAdvancementDeterminator<SimulationJumper>();
        final context = MockKoRoundNBestAdvancementDeterminingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Kamil', 'Stoch'),
          createJumper('Giovanni', 'Bresadola'),
          createJumper('Martin', 'Hamann'),
        ];
        final standings = Standings(
          positionsCreator: StandingsPositionsWithExAequosCreator(),
          initialScores: [
            SimpleScore(
              subject: jumpers[0],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[1],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[2],
              points: 105.4,
            ),
          ],
        );
        provideDummy(standings);
        when(context.entities).thenReturn(jumpers);
        when(context.limit).thenReturn(const EntitiesLimit.soft(1));
        when(context.koStandings).thenReturn(
          standings,
        );
        final advanced = determinator.determineAdvancement(context);
        expect(advanced.toSet(), {jumpers[0], jumpers[1]});
      });

      test('Soft limit (count: 2) + ex aequo on first place', () {
        const determinator = NBestKoRoundAdvancementDeterminator<SimulationJumper>();
        final context = MockKoRoundNBestAdvancementDeterminingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Kamil', 'Stoch'),
          createJumper('Giovanni', 'Bresadola'),
          createJumper('Martin', 'Hamann'),
        ];
        final standings = Standings(
          positionsCreator: StandingsPositionsWithExAequosCreator(),
          initialScores: [
            SimpleScore(
              subject: jumpers[0],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[1],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[2],
              points: 105.4,
            ),
          ],
        );
        provideDummy(standings);
        when(context.entities).thenReturn(jumpers);
        when(context.limit).thenReturn(const EntitiesLimit.soft(2));
        when(context.koStandings).thenReturn(
          standings,
        );
        final advanced = determinator.determineAdvancement(context);
        expect(advanced.toSet(), {jumpers[0], jumpers[1]});
      });

      test('No limit', () {
        const determinator = NBestKoRoundAdvancementDeterminator<SimulationJumper>();
        final context = MockKoRoundNBestAdvancementDeterminingContext<SimulationJumper>();
        final jumpers = [
          createJumper('Kamil', 'Stoch'),
          createJumper('Giovanni', 'Bresadola'),
          createJumper('Martin', 'Hamann'),
        ];
        final standings = Standings(
          positionsCreator: StandingsPositionsWithShuffleOnEqualPositionsCreator(),
          initialScores: [
            SimpleScore(
              subject: jumpers[0],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[1],
              points: 127.7,
            ),
            SimpleScore(
              subject: jumpers[2],
              points: 105.4,
            ),
          ],
        );
        provideDummy(standings);
        when(context.entities).thenReturn(jumpers);
        when(context.limit).thenReturn(null);
        when(context.koStandings).thenReturn(
          standings,
        );
        final advanced = determinator.determineAdvancement(context);
        expect(advanced, jumpers);
      });
    });
  });
}
