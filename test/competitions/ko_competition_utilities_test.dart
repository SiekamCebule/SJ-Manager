import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/ko/ko_group.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_random.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/concrete/default_with_pots.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/ko_group_creator.dart/ko_groups_creator.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

import 'ko_competition_utilities_test.mocks.dart';

@GenerateMocks([
  KoGroupsCreatingContext,
  ClassicKoGroupsCreatingContext,
  RandomKoGroupsCreatingContext,
  KoGroupsPotsCreatingContext,
])
void main() {
  group(KoGroupsCreator, () {
    const country = Country.emptyNone();
    group(DefaultClassicKoGroupsCreator, () {
      test(
          'Creates groups for 8 jumpers in good order (groups\'s order and the order wihin group). Checks if passing uneven number causes an error',
          () {
        final context = MockClassicKoGroupsCreatingContext<Jumper>();
        final jumpers = [
          Jumper.empty(country: country).copyWith(name: 'Dawid', surname: 'Kubacki'),
          Jumper.empty(country: country).copyWith(name: 'Piotr', surname: 'Żyła'),
          Jumper.empty(country: country).copyWith(name: 'David', surname: 'Siegel'),
          Jumper.empty(country: country)
              .copyWith(name: 'Tymoteusz', surname: 'Amilkiewicz'),
          Jumper.empty(country: country).copyWith(name: 'Yevhen', surname: 'Marusiak'),
          Jumper.empty(country: country).copyWith(name: 'Evgeniy', surname: 'Klimov'),
          Jumper.empty(country: country).copyWith(name: 'Robert', surname: 'Johansson'),
        ];
        final creator = DefaultClassicKoGroupsCreator<Jumper>();
        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        expect(
          () {
            creator.compute(context);
          },
          throwsA(isA<ArgumentError>()),
        );
        jumpers.add(
          Jumper.empty(country: country)
              .copyWith(name: 'Halvor Egner', surname: 'Granerud'),
        );
        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        final groups = creator.compute(context);
        expect(groups, [
          KoGroup(entities: [jumpers[4], jumpers[3]]),
          KoGroup(entities: [jumpers[5], jumpers[2]]),
          KoGroup(entities: [jumpers[6], jumpers[1]]),
          KoGroup(entities: [jumpers[7], jumpers[0]]),
        ]);
      });
    });

    group(DefaultRandomKoGroupsCreator, () {
      test('Entities count fits perfectly', () {
        final context = MockRandomKoGroupsCreatingContext<Jumper>();
        final jumpers = [
          Jumper.empty(country: country).copyWith(name: 'Jumper 1'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 2'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 3'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 4'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 5'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 6'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 7'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 8'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 9'),
        ];
        final creator = DefaultRandomKoGroupsCreator<Jumper>();

        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        when(context.entitiesInGroup).thenReturn(3);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.throwError);

        final groups = creator.compute(context);

        expect(groups.length, 3);
        expect(groups.every((group) => group.entities.length == 3), isTrue);
        expect(groups.expand((group) => group.entities).toSet().length,
            jumpers.length); // no duplicates
      });

      test('Uneven groups, remainingEntitiesAction - placeInSmallestGroup', () {
        final context = MockRandomKoGroupsCreatingContext<Jumper>();
        final jumpers = [
          Jumper.empty(country: country).copyWith(name: 'Jumper 1'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 2'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 3'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 4'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 5'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 6'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 7'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 8'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 9'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 10'),
        ];
        final creator = DefaultRandomKoGroupsCreator<Jumper>();

        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeInSmallestGroup);

        final groups = creator.compute(context);

        expect(groups.length, 3);
        expect(groups.where((group) => group.entities.length == 4).length, 1);
        expect(groups.where((group) => group.entities.length == 3).length, 2);
        expect(groups.expand((group) => group.entities).toSet().length,
            jumpers.length); // no duplicates
      });

      test('Uneven groups, remainingEntitiesAction - placeRandomly', () {
        final context = MockRandomKoGroupsCreatingContext<Jumper>();
        final jumpers = [
          Jumper.empty(country: country).copyWith(name: 'Jumper 1'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 2'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 3'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 4'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 5'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 6'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 7'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 8'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 9'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 10'),
        ];
        final creator = DefaultRandomKoGroupsCreator<Jumper>();

        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeInSmallestGroup);

        final groups = creator.compute(context);

        expect(groups.length, 3);
        expect(groups.where((group) => group.entities.length == 4).length,
            anyOf(isZero, equals(1)));
        expect(groups.expand((group) => group.entities).toSet().length,
            jumpers.length); // no duplicates
      });

      test('Uneven groups, remainingEntitiesAction - placeAtBegin', () {
        final context = MockRandomKoGroupsCreatingContext<Jumper>();
        final jumpers = [
          Jumper.empty(country: country).copyWith(name: 'Jumper 1'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 2'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 3'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 4'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 5'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 6'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 7'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 8'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 9'),
          Jumper.empty(country: country).copyWith(name: 'Jumper 10'),
        ];
        final creator = DefaultRandomKoGroupsCreator<Jumper>();

        when(context.entities).thenReturn(jumpers);
        when(context.entitiesCount).thenReturn(jumpers.length);
        when(context.entitiesInGroup).thenReturn(4);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.placeAtBegin);

        final groups = creator.compute(context);
        expect(groups.length, 3);
        expect(groups.first.entities.length, 4);
        expect(groups.where((group) => group.entities.length == 3).length, 2);
        expect(groups.expand((group) => group.entities).toSet().length,
            jumpers.length); // no duplicates
      });
    });

    group(DefaultPotsKoGroupsCreator, () {
      test('Typical scenario', () {
        final context = MockKoGroupsPotsCreatingContext();
        final pots = [
          [
            Jumper.empty(country: country).copyWith(name: 'Jumper 1'),
            Jumper.empty(country: country).copyWith(name: 'Jumper 2'),
            Jumper.empty(country: country).copyWith(name: 'Jumper 3'),
          ],
          [
            Jumper.empty(country: country).copyWith(name: 'Jumper 4'),
            Jumper.empty(country: country).copyWith(name: 'Jumper 5'),
            Jumper.empty(country: country).copyWith(name: 'Jumper 6'),
          ],
          [
            Jumper.empty(country: country).copyWith(name: 'Jumper 7'),
            Jumper.empty(country: country).copyWith(name: 'Jumper 8'),
            Jumper.empty(country: country).copyWith(name: 'Jumper 9'),
          ],
          [
            Jumper.empty(country: country).copyWith(name: 'Jumper 10'),
            Jumper.empty(country: country).copyWith(name: 'Jumper 11'),
            Jumper.empty(country: country).copyWith(name: 'Jumper 12'),
          ],
        ];
        final creator = DefaultPotsKoGroupsCreator();

        when(context.pots).thenReturn(pots);
        when(context.entitiesCount)
            .thenReturn(pots.expand((entities) => entities).length);
        when(context.entitiesInGroup).thenReturn(3);
        when(context.remainingEntitiesAction)
            .thenReturn(KoGroupsCreatorRemainingEntitiesAction.throwError);

        final groups = creator.compute(context);
        expect(groups.length, 4);
        expect(groups.every((group) => group.entities.length == 3), isTrue);
        expect(groups[0].entities, containsAll(pots[0]));
        expect(groups[1].entities, containsAll(pots[1]));
        expect(groups[2].entities, containsAll(pots[2]));
        expect(groups[3].entities, containsAll(pots[3]));
      });

      test('Typical scenario', () {});
    });
  });
}
