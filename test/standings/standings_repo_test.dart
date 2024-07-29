import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/models/db/event_series/standings/score/basic_score_types.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_record.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';

void main() {
  group(StandingsRepo, () {
    late StandingsRepo<String, SimplePointsScore,
        StandingsRecord<String, SimplePointsScore>> repo;

    test('Adding, editing and removing; updating standings', () {
      const stoch =
          StandingsRecord(entity: 'Kamil Stoch', score: SimplePointsScore(315.5));
      const kubacki =
          StandingsRecord(entity: 'Dawid Kubacki', score: SimplePointsScore(333.4));
      const zyla = StandingsRecord(entity: 'Piotr Żyła', score: SimplePointsScore(315.5));
      const geiger =
          StandingsRecord(entity: 'Karl Geiger', score: SimplePointsScore(330.0));
      const eisenbichler =
          StandingsRecord(entity: 'Markus Eisenbichler', score: SimplePointsScore(350.1));

      repo = StandingsRepo(
        positionsCreator: StandingsPositionsWithExAequosCreator(),
        initialRecords: const [stoch, kubacki, zyla],
      );

      repo.update(newRecord: geiger);
      repo.update(newRecord: eisenbichler);
      expect(repo.leaders.single, eisenbichler);
      expect(repo.last.values.last, [stoch, zyla]); // Records at last position
      expect(repo.length, 5);
      repo.remove(record: eisenbichler);
      expect(repo.leaders.single, kubacki);
      expect(repo.length, 4);
      expect(repo.containsEntity('Markus Eisenbichler'), false);
      repo.update(newRecord: stoch.copyWith(score: const SimplePointsScore(441.4)));
      expect(repo.leaders.single.entity, 'Kamil Stoch');
      expect(repo.length, 4);

      repo.dispose();
    });

    group('Repo view utilities', () {
      const kot = StandingsRecord(entity: 'Maciej Kot', score: SimplePointsScore(116.4));
      const hula =
          StandingsRecord(entity: 'Stefan Hula', score: SimplePointsScore(116.4));
      const kobayashi =
          StandingsRecord(entity: 'Ryoyu Kobayashi', score: SimplePointsScore(137.8));
      const danielHuber =
          StandingsRecord(entity: 'Daniel Huber', score: SimplePointsScore(137.8));
      const stefanHuber =
          StandingsRecord(entity: 'Stefan Huber', score: SimplePointsScore(120.1));
      const wohlgenannt =
          StandingsRecord(entity: 'Ulrich Wohlgenannt', score: SimplePointsScore(111.5));
      const kos = StandingsRecord(entity: 'Lovro Kos', score: SimplePointsScore(127.5));
      const prevc =
          StandingsRecord(entity: 'Domen Prevc', score: SimplePointsScore(114.9));
      const peier =
          StandingsRecord(entity: 'Killian Peier', score: SimplePointsScore(110.8));

      setUpAll(() {
        repo = StandingsRepo(
          positionsCreator: StandingsPositionsWithExAequosCreator(),
          initialRecords: const [
            kot,
            hula,
            kobayashi,
            danielHuber,
            stefanHuber,
            wohlgenannt,
            kos,
            prevc,
            peier,
          ],
        );
      });

      test('leaders', () {
        expect(repo.leaders, [kobayashi, danielHuber]);
        expect(() => repo.leaders.single, throwsA(isA<StateError>()));
      });

      test('records by position', () {
        expect(repo.leaders, repo.atPosition(1));
        expect(repo.atPosition(4), [stefanHuber]);
        expect(() => repo.atPosition(0), throwsA(isA<StateError>()));
        expect(() => repo.atPosition(18), throwsA(isA<StateError>()));
      });

      test('position by entity', () {
        expect(repo.positionOf('Ulrich Wohlgenannt'), 8);
        expect(repo.positionOf('Stefan Huber'), 4);
        expect(() => repo.positionOf('Karol Wojtyła'), throwsA(isA<StateError>()));
      });

      test('score by entity', () {
        expect(repo.scoreOf('Domen Prevc'), const SimplePointsScore(114.9));
        expect(repo.scoreOf('Daniel Huber'), const SimplePointsScore(137.8));
        expect(() => repo.scoreOf('Peter Prevc'), throwsA(isA<StateError>()));
      });

      test('length', () {
        expect(repo.length, 9);
      });

      test('whether contains an entity', () {
        expect(repo.containsEntity('Stefan Hula'), true);
        expect(repo.containsEntity('Stefan Huber'), true);
        expect(repo.containsEntity('Junshiro Kobayashi'), false);
      });

      tearDownAll(() {
        repo.dispose();
      });
    });
  });
}
