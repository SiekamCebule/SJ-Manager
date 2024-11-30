import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/score.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings.dart';

void main() {
  group(Standings, () {
    late Standings<String, SimplePointsScoreDetails> standings;

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

      standings = Standings(
        positionsCreator: StandingsPositionsWithExAequosCreator(),
        initialScores: const [stoch, kubacki, zyla],
      );

      standings.addScore(newScore: geiger);
      standings.addScore(newScore: eisenbichler);
      expect(standings.leaders.single, eisenbichler);
      expect(standings.scores.last, [stoch, zyla]); // Scores at last position
      expect(standings.length, 5);
      standings.remove(score: eisenbichler);
      expect(standings.leaders.single, kubacki);
      expect(standings.length, 4);
      expect(standings.containsEntity('Markus Eisenbichler'), false);
      standings.addScore(newScore: stoch.copyWith(points: 441.4), overwrite: true);
      expect(standings.leaders.single.entity, 'Kamil Stoch');
      expect(standings.length, 4);

      standings.dispose();
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
        standings = Standings(
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
        expect(standings.leaders, [kobayashi, danielHuber]);
        expect(() => standings.leaders.single, throwsA(isA<StateError>()));
      });

      test('scores by position', () {
        expect(standings.leaders, standings.atPosition(1));
        expect(standings.atPosition(4), [stefanHuber]);
        expect(() => standings.atPosition(0), throwsA(isA<StateError>()));
        expect(() => standings.atPosition(18), throwsA(isA<StateError>()));
      });

      test('position by entity', () {
        expect(standings.positionOf('Ulrich Wohlgenannt'), 8);
        expect(standings.positionOf('Stefan Huber'), 4);
        expect(standings.positionOf('Karol Wojtyła'), isNull);
      });

      test('score by entity', () {
        expect(
            standings.scoreOf('Domen Prevc'),
            const Score<String, SimplePointsScoreDetails>(
              entity: 'Domen Prevc',
              points: 114.9,
              details: SimplePointsScoreDetails(),
            ));
        expect(
            standings.scoreOf('Daniel Huber'),
            const Score<String, SimplePointsScoreDetails>(
              entity: 'Daniel Huber',
              points: 137.8,
              details: SimplePointsScoreDetails(),
            ));
        expect(standings.scoreOf('Peter Prevc'), isNull);
      });

      test('length', () {
        expect(standings.length, 9);
      });

      test('whether contains an entity', () {
        expect(standings.containsEntity('Stefan Hula'), true);
        expect(standings.containsEntity('Stefan Huber'), true);
        expect(standings.containsEntity('Junshiro Kobayashi'), false);
      });

      tearDownAll(() {
        standings.dispose();
      });
    });
  });
}
