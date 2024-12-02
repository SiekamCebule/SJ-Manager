import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/classification_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/context/simple_classification_score_creating_context.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/simple/simple_classification_jumper_score_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';
import 'package:sj_manager/to_embrace/classification/simple_classification_rules.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/competition_labels.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/to_embrace/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';

import 'classification_rules_utilities_test.mocks.dart';

@GenerateMocks([
  Competition,
  Standings,
  SimpleClassification,
  SimpleIndividualClassificationRules,
  SimpleClassificationJumperScoreCreatingContext,
  Score,
  SimulationJumper,
  CompetitionJumperScore,
  DefaultIndividualCompetitionRoundRules,
  DefaultCompetitionRules,
])
void main() {
  group('ClassificationScoreCreator', () {
    group('DefaultClassificationScoreCreator', () {
      test('SimpleClassificationJumperScoreCreator', () {
        final creator = SimpleClassificationJumperScoreCreator();
        final context = MockSimpleClassificationJumperScoreCreatingContext();
        final jumper = MockSimulationJumper();
        final classification = MockSimpleClassification<SimulationJumper>();
        final scores = [
          MockCompetitionJumperScore(),
          MockCompetitionJumperScore(),
          MockCompetitionJumperScore(),
          MockCompetitionJumperScore(),
        ].cast<CompetitionJumperScore>();

        List<Competition<SimulationJumper>> competitions = [
          setupCompetition(jumper, scores[0], 2),
          setupCompetition(jumper, scores[1], 7),
          setupCompetition(jumper, scores[2], 5),
          setupCompetition(jumper, scores[3], 2),
        ];

        final classificationRules = MockSimpleIndividualClassificationRules();
        when(classificationRules.scoreCreator).thenReturn(creator);
        when(classificationRules.competitions).thenReturn(competitions);
        when(classificationRules.pointsMap).thenReturn({
          1: 100,
          2: 50,
          3: 20,
          4: 10,
          5: 5,
          6: 1,
        });

        when(classificationRules.scoringType)
            .thenReturn(SimpleClassificationScoringType.pointsFromMap);
        when(classification.rules).thenReturn(classificationRules);
        when(context.subject).thenReturn(jumper);
        when(context.classification).thenReturn(classification);

        final score = creator.create(context);

        expect(
          score,
          ClassificationJumperScore(
            subject: jumper,
            points: 105.0,
            competitionScores: scores,
            classification: classification,
          ),
        );
      });
    });
  });
}

MockCompetition<SimulationJumper> setupCompetition(
  SimulationJumper jumper,
  Score<SimulationJumper> score,
  int position,
) {
  final competition = MockCompetition<SimulationJumper>();
  final standings = MockStandings();
  when(standings.scoreOf(jumper)).thenReturn(score);
  when(standings.positionOf(jumper)).thenReturn(position);
  when(competition.standings).thenReturn(standings);
  when(competition.rules).thenReturn(MockDefaultCompetitionRules());
  when(competition.labels).thenReturn([CompetitionPlayedStatus.played]);
  return competition;
}
