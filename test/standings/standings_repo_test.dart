import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/test_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/features/competitions/domain/utils/standings_position_creators/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

@GenerateMocks([SimulationJumper])
void main() {
  group('Standings', () {
    late Standings standings;

    test('Adding, editing and removing; updating standings', () {
      const stoch = SimpleScore(subject: 'Kamil Stoch', points: 315.5);
      const kubacki = SimpleScore(subject: 'Dawid Kubacki', points: 333.4);
      const zyla = SimpleScore(subject: 'Piotr Żyła', points: 315.5);
      const geiger = SimpleScore(subject: 'Karl Geiger', points: 330.0);
      const eisenbichler = SimpleScore(subject: 'Markus Eisenbichler', points: 350.1);

      standings = Standings(
        positionsCreator: StandingsPositionsWithExAequosCreator(),
        initialScores: const [stoch, kubacki, zyla],
      );

      standings.add(geiger);
      standings.add(eisenbichler);
      expect(standings.leaders!.single, eisenbichler);
      expect(standings.length, 5);
      standings.remove(eisenbichler);
      expect(standings.leaders!.single, kubacki);
      expect(standings.length, 4);
      expect(standings.scoreOf('Markus Eisenbichler'), isNotNull);
      standings.add(stoch.copyWith(points: 441.4), overwrite: true);
      expect(standings.leaders!.single.subject, 'Kamil Stoch');
      expect(standings.length, 4);
    });

    group('Repo view utilities', () {
      const scores = [
        SimpleScore(subject: 'Maciej Kot', points: 116.4),
        SimpleScore(subject: 'Stefan Hula', points: 116.4),
        SimpleScore(subject: 'Ryoyu Kobayashi', points: 137.8),
        SimpleScore(subject: 'Daniel Huber', points: 137.8),
        SimpleScore(subject: 'Stefan Huber', points: 120.1),
        SimpleScore(subject: 'Ulrich Wohlgenannt', points: 111.5),
        SimpleScore(subject: 'Lovro Kos', points: 127.5),
        SimpleScore(subject: 'Domen Prevc', points: 114.9),
        SimpleScore(subject: 'Killian Peier', points: 110.8),
      ];

      setUpAll(() {
        standings = Standings(
          positionsCreator: StandingsPositionsWithExAequosCreator(),
          initialScores: scores,
        );
      });

      test('leaders', () {
        expect(
          standings.leaders,
          scores.where((e) => e.points == 137.8).toList(),
        );
      });

      test('length', () {
        expect(standings.length, scores.length);
      });

      test('whether contains an entity', () {
        expect(standings.scoreOf('Stefan Hula'), isNotNull);
        expect(standings.scoreOf('Junshiro Kobayashi'), isNotNull);
      });
    });
  });
}
