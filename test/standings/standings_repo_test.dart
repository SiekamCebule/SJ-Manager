import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';

void main() {
  group(Standings, () {
    late Standings<String, SimplePointsScoreDetails> repo;

    test('Adding, editing and removing; updating standings', () {
      const stoch = Score<String, SimplePointsScoreDetails>(
        entity: 'Kamil Stoch',
        points: 315.5,
        details: SimplePointsScoreDetails(),
      );
      const kubacki = Score<String, SimplePointsScoreDetails>(
        entity: 'Dawid Kubacki',
        points: 333.4,
        details: SimplePointsScoreDetails(),
      );
      const zyla = Score<String, SimplePointsScoreDetails>(
        entity: 'Piotr Żyła',
        points: 315.5,
        details: SimplePointsScoreDetails(),
      );
      const geiger = Score<String, SimplePointsScoreDetails>(
        entity: 'Karl Geiger',
        points: 330.0,
        details: SimplePointsScoreDetails(),
      );
      const eisenbichler = Score<String, SimplePointsScoreDetails>(
        entity: 'Markus Eisenbichler',
        points: 350.1,
        details: SimplePointsScoreDetails(),
      );

      repo = Standings(
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
      repo.addScore(newScore: stoch.copyWith(points: 441.4), overwrite: true);
      expect(repo.leaders.single.entity, 'Kamil Stoch');
      expect(repo.length, 4);

      repo.dispose();
    });

    group('Repo view utilities', () {
      const kot = Score<String, SimplePointsScoreDetails>(
        entity: 'Maciej Kot',
        points: 116.4,
        details: SimplePointsScoreDetails(),
      );
      const hula = Score<String, SimplePointsScoreDetails>(
        entity: 'Stefan Hula',
        points: 116.4,
        details: SimplePointsScoreDetails(),
      );
      const kobayashi = Score<String, SimplePointsScoreDetails>(
        entity: 'Ryoyu Kobayashi',
        points: 137.8,
        details: SimplePointsScoreDetails(),
      );
      const danielHuber = Score<String, SimplePointsScoreDetails>(
        entity: 'Daniel Huber',
        points: 137.8,
        details: SimplePointsScoreDetails(),
      );
      const stefanHuber = Score<String, SimplePointsScoreDetails>(
        entity: 'Stefan Huber',
        points: 120.1,
        details: SimplePointsScoreDetails(),
      );
      const wohlgenannt = Score<String, SimplePointsScoreDetails>(
        entity: 'Ulrich Wohlgenannt',
        points: 111.5,
        details: SimplePointsScoreDetails(),
      );
      const kos = Score<String, SimplePointsScoreDetails>(
        entity: 'Lovro Kos',
        points: 127.5,
        details: SimplePointsScoreDetails(),
      );
      const prevc = Score<String, SimplePointsScoreDetails>(
        entity: 'Domen Prevc',
        points: 114.9,
        details: SimplePointsScoreDetails(),
      );
      const peier = Score<String, SimplePointsScoreDetails>(
        entity: 'Killian Peier',
        points: 110.8,
        details: SimplePointsScoreDetails(),
      );

      setUpAll(() {
        repo = Standings(
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
        expect(repo.positionOf('Karol Wojtyła'), isNull);
      });

      test('score by entity', () {
        expect(
            repo.scoreOf('Domen Prevc'),
            const Score<String, SimplePointsScoreDetails>(
              entity: 'Domen Prevc',
              points: 114.9,
              details: SimplePointsScoreDetails(),
            ));
        expect(
            repo.scoreOf('Daniel Huber'),
            const Score<String, SimplePointsScoreDetails>(
              entity: 'Daniel Huber',
              points: 137.8,
              details: SimplePointsScoreDetails(),
            ));
        expect(repo.scoreOf('Peter Prevc'), isNull);
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
