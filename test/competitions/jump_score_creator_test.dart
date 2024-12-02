import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/features/competitions/domain/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/features/competitions/domain/utils/jump_score_creator/context/jump_score_creating_context.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/core_classes/hill/hill.dart';

import 'jump_score_creator_test.mocks.dart';

@GenerateMocks([
  JumpScoreCreatingContext<SimulationJumper>,
  DefaultIndividualCompetitionRoundRules,
  SimulationJumper,
])
void main() {
  group(DefaultClassicJumpScoreCreator, () {
    late DefaultClassicJumpScoreCreator creator;

    setUp(() {
      creator = DefaultClassicJumpScoreCreator();
    });

    test('Normal jump', () {
      final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
      final jumper = MockSimulationJumper();
      provideDummy(jumper);
      final context = MockJumpScoreCreatingContext<SimulationJumper>();

      when(context.subject).thenReturn(jumper);
      final hill = Hill.empty(country: germany).copyWith(
        k: 125,
        pointsForGate: 7.0,
        pointsForHeadwind: 10.8,
        pointsForTailwind: 16.2,
      );
      when(context.hill).thenReturn(hill);
      when(context.initialGate).thenReturn(15);
      when(context.gate).thenReturn(13);
      when(context.averagedWind).thenReturn(1.2);
      when(context.jump).thenReturn(
        const JumpSimulationRecord(
          distance: 137.0,
          landingType: LandingType.telemark,
        ),
      );
      when(context.judges).thenReturn([18.0, 19.0, 19.5, 19.0, 19.0]);
      when(context.currentRound).thenReturn(0);
      final roundRules = MockDefaultIndividualCompetitionRoundRules();
      when(roundRules.judgesEnabled).thenReturn(true);
      when(roundRules.significantJudgesCount).thenReturn(3);
      when(roundRules.gateCompensationsEnabled).thenReturn(true);
      when(roundRules.windCompensationsEnabled).thenReturn(true);
      when(context.competition).thenReturn(Competition(
        hill: hill,
        date: DateTime.now(),
        rules: const DefaultCompetitionRules.empty().copyWith(rounds: [roundRules]),
      ));
      final score = creator.create(context);

      expect(
        score,
        CompetitionJumpScore(
          subject: jumper,
          jump: context.jump,
          distancePoints: 81.6,
          judgePoints: 57.0,
          gatePoints: 14.0,
          windPoints: -12.96,
          points: 139.6,
          competition: context.competition,
        ),
      );
    });

    test('Without gate points and only 2 significant judges', () {
      final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
      final jumper = MockSimulationJumper();
      provideDummy(jumper);
      final context = MockJumpScoreCreatingContext<SimulationJumper>();

      when(context.subject).thenReturn(jumper);
      final hill = Hill.empty(country: germany).copyWith(
        k: 130,
        pointsForGate: 7.8,
        pointsForHeadwind: 10.8,
        pointsForTailwind: 16.2,
      );
      when(context.hill).thenReturn(hill);
      when(context.initialGate).thenReturn(15);
      when(context.gate).thenReturn(13);
      when(context.windDuringJump).thenReturn(
        WindMeasurement(
          winds: {
            (0, 22): Wind(direction: Degrees(121.5), strength: 1.44),
            (22, 44): Wind(direction: Degrees(180.5), strength: 1.7),
            (44, 66): Wind(direction: Degrees(40.5), strength: 3.0),
            (66, 88): Wind(direction: Degrees(200.9), strength: 1.01),
            (88, 110): Wind(direction: Degrees(140.5), strength: 0.66),
            (110, 132): Wind(direction: Degrees(90.11), strength: 3.5),
            (132, 154): Wind(direction: Degrees(190.5), strength: 5.0),
          },
        ),
      );
      when(context.averagedWind).thenReturn(1.2);
      when(context.jump).thenReturn(
        const JumpSimulationRecord(distance: 142.0, landingType: LandingType.telemark),
      );
      when(context.judges).thenReturn([18.0, 18.0, 19.0, 19.0, 17.5, 17.0]);
      when(context.currentRound).thenReturn(0);
      final roundRules = MockDefaultIndividualCompetitionRoundRules();
      when(roundRules.judgesEnabled).thenReturn(true);
      when(roundRules.significantJudgesCount).thenReturn(2);
      when(roundRules.gateCompensationsEnabled).thenReturn(false);
      when(roundRules.windCompensationsEnabled).thenReturn(true);
      when(context.competition).thenReturn(Competition(
        hill: hill,
        date: DateTime.now(),
        rules: const DefaultCompetitionRules.empty().copyWith(rounds: [roundRules]),
      ));
      final score = creator.create(context);

      expect(
        score,
        CompetitionJumpScore(
          subject: jumper,
          jump: context.jump,
          distancePoints: 81.6,
          judgePoints: 36.0,
          gatePoints: null,
          windPoints: -12.96,
          points: 104.6,
          competition: context.competition,
        ),
      );
    });

    test('Negative points (short distance)', () {
      final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
      final jumper = MockSimulationJumper();
      provideDummy(jumper);
      final context = MockJumpScoreCreatingContext<SimulationJumper>();

      when(context.subject).thenReturn(jumper);
      final hill = Hill.empty(country: germany).copyWith(
        k: 130,
        pointsForGate: 7,
        pointsForHeadwind: 10.8,
        pointsForTailwind: 16.2,
      );
      when(context.hill).thenReturn(hill);
      when(context.initialGate).thenReturn(15);
      when(context.gate).thenReturn(13);
      when(context.windDuringJump).thenReturn(
        WindMeasurement(
          winds: {
            (0, 22): Wind(direction: Degrees(121.5), strength: 1.44),
            (22, 44): Wind(direction: Degrees(180.5), strength: 1.7),
            (44, 66): Wind(direction: Degrees(40.5), strength: 3.0),
            (66, 88): Wind(direction: Degrees(200.9), strength: 1.01),
            (88, 110): Wind(direction: Degrees(140.5), strength: 0.66),
            (110, 132): Wind(direction: Degrees(90.11), strength: 3.5),
            (132, 154): Wind(direction: Degrees(190.5), strength: 5.0),
          },
        ),
      );
      when(context.averagedWind).thenReturn(1.2);
      when(context.jump).thenReturn(
        const JumpSimulationRecord(distance: 65.0, landingType: LandingType.telemark),
      );
      when(context.judges).thenReturn([15.0, 16.0, 16.0, 15.5, 16.0]);
      when(context.currentRound).thenReturn(0);
      final roundRules = MockDefaultIndividualCompetitionRoundRules();
      when(roundRules.judgesEnabled).thenReturn(true);
      when(roundRules.significantJudgesCount).thenReturn(3);
      when(roundRules.gateCompensationsEnabled).thenReturn(true);
      when(roundRules.windCompensationsEnabled).thenReturn(true);
      when(context.competition).thenReturn(Competition(
        hill: hill,
        date: DateTime.now(),
        rules: const DefaultCompetitionRules.empty().copyWith(rounds: [roundRules]),
      ));
      final score = creator.create(context);

      expect(
        score,
        CompetitionJumpScore(
          subject: jumper,
          jump: context.jump,
          distancePoints: -57,
          judgePoints: 47.5,
          gatePoints: 14.0,
          windPoints: -12.96,
          points: 0, // -8.4
          competition: context.competition,
        ),
      );
    });
  });
}
