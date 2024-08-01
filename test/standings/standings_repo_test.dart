import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/models/db/event_series/standings/score/concrete/simple_points_score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';

void main() {
  group(StandingsRepo, () {
    late StandingsRepo<String> repo;

    test('Adding, editing and removing; updating standings', () {
      const stoch = SimplePointsScore(315.5, entity: 'Kamil Stoch');
      const kubacki = SimplePointsScore(333.4, entity: 'Dawid Kubacki');
      const zyla = SimplePointsScore(315.5, entity: 'Piotr Żyła');
      const geiger = SimplePointsScore(330.0, entity: 'Karl Geiger');
      const eisenbichler = SimplePointsScore(350.1, entity: 'Markus Eisenbichler');

      repo = StandingsRepo(
        positionsCreator: StandingsPositionsWithExAequosCreator(),
        initialScores: const [stoch, kubacki, zyla],
      );

      repo.addScore(newScore: geiger);
      repo.addScore(newScore: eisenbichler);
      expect(repo.leaders.single, eisenbichler);
      expect(repo.last.values.last, [stoch, zyla]); // Scores at last position
      expect(repo.length, 5);
      repo.remove(score: eisenbichler);
      expect(repo.leaders.single, kubacki);
      expect(repo.length, 4);
      expect(repo.containsEntity('Markus Eisenbichler'), false);
      repo.addScore(newScore: stoch.copyWith(points: 441.4));
      expect(repo.leaders.single.entity, 'Kamil Stoch');
      expect(repo.length, 4);

      repo.dispose();
    });

    group('Repo view utilities', () {
      const kot = SimplePointsScore(116.4, entity: 'Maciej Kot');
      const hula = SimplePointsScore(116.4, entity: 'Stefan Hula');
      const kobayashi = SimplePointsScore(137.8, entity: 'Ryoyu Kobayashi');
      const danielHuber = SimplePointsScore(137.8, entity: 'Daniel Huber');
      const stefanHuber = SimplePointsScore(120.1, entity: 'Stefan Huber');
      const wohlgenannt = SimplePointsScore(111.5, entity: 'Ulrich Wohlgenannt');
      const kos = SimplePointsScore(127.5, entity: 'Lovro Kos');
      const prevc = SimplePointsScore(114.9, entity: 'Domen Prevc');
      const peier = SimplePointsScore(110.8, entity: 'Killian Peier');

      setUpAll(() {
        repo = StandingsRepo(
          positionsCreator: StandingsPositionsWithExAequosCreator(),
          initialScores: const [
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

      test('scores by position', () {
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
        expect(repo.scoreOf('Domen Prevc'),
            const SimplePointsScore(114.9, entity: 'Domen Prevc'));
        expect(repo.scoreOf('Daniel Huber'),
            const SimplePointsScore(137.8, entity: 'Daniel Huber'));
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
