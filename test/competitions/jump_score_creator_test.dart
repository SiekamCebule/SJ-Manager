import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation/competition/competition.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/jump_score_creator/concrete/default_classic.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation/standings/score/details/jump_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/score.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

import 'jump_score_creator_test.mocks.dart';

@GenerateMocks([
  JumpScoreCreatingContext<Jumper>,
  DefaultIndividualCompetitionRoundRules,
])
void main() {
  group(DefaultClassicJumpScoreCreator, () {
    late DefaultClassicJumpScoreCreator<Jumper> creator;

    setUp(() {
      creator = DefaultClassicJumpScoreCreator();
    });

    test('Normal jump', () {
      final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
      final jumper =
          Jumper.empty(country: germany).copyWith(name: 'David', surname: 'Siegel');
      provideDummy(jumper);
      final context = MockJumpScoreCreatingContext<Jumper>();

      when(context.entity).thenReturn(jumper);
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
      when(context.jumpRecord).thenReturn(
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
      final score = creator.compute(context);

      expect(
        score,
        Score(
          entity: jumper,
          details: CompetitionJumpScoreDetails(
            jumpRecord: context.jumpRecord,
            distancePoints: 81.6,
            judgesPoints: 57.0,
            gatePoints: 14.0,
            windPoints: -12.96,
          ),
          points: 139.6,
        ),
      );
    });

    test('Without gate points and only 2 significant judges', () {
      final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
      final jumper =
          Jumper.empty(country: germany).copyWith(name: 'David', surname: 'Siegel');
      provideDummy(jumper);
      final context = MockJumpScoreCreatingContext<Jumper>();

      when(context.entity).thenReturn(jumper);
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
      when(context.jumpRecord).thenReturn(
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
      final score = creator.compute(context);

      expect(
        score,
        Score(
          entity: jumper,
          details: CompetitionJumpScoreDetails(
            jumpRecord: context.jumpRecord,
            distancePoints: 81.6,
            judgesPoints: 36.0,
            gatePoints: null,
            windPoints: -12.96,
          ),
          points: 104.6,
        ),
      );
    });

    test('Negative points (small distance)', () {
      final germany = Country.monolingual(code: 'de', language: 'en', name: 'Germany');
      final jumper =
          Jumper.empty(country: germany).copyWith(name: 'David', surname: 'Siegel');
      provideDummy(jumper);
      final context = MockJumpScoreCreatingContext<Jumper>();

      when(context.entity).thenReturn(jumper);
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
      when(context.jumpRecord).thenReturn(
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
      final score = creator.compute(context);

      expect(
        score,
        Score(
          entity: jumper,
          details: CompetitionJumpScoreDetails(
            jumpRecord: context.jumpRecord,
            distancePoints: -57,
            judgesPoints: 47.5,
            gatePoints: 14.0,
            windPoints: -12.96,
          ),
          points: 0, // -8.4
        ),
      );
    });
  });
}
