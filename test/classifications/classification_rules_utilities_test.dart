import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sj_manager/domain/entities/simulation/classification/classification.dart';
import 'package:sj_manager/domain/entities/simulation/classification/default_classification_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition.dart';
import 'package:sj_manager/domain/entities/simulation/competition/competition_labels.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_round_rules/default_individual_competition_round_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/competition_rules/default_competition_rules.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/domain/entities/simulation/competition/rules/utils/classification_score_creator/concrete/individual_default.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/score.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/typedefs.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';

import 'classification_rules_utilities_test.mocks.dart';

@GenerateMocks([
  Competition,
  Standings,
  DefaultClassification,
  DefaultIndividualClassificationRules,
  DefaultIndividualClassificationScoreCreatingContext,
  Score,
  DefaultIndividualCompetitionRoundRules,
  DefaultCompetitionRules,
])
void main() {
  group('ClassificationScoreCreator', () {
    group('DefaultClassificationScoreCreator', () {
      test('DefaultIndividualClassificationScoreCreator', () {
        final creator = DefaultIndividualClassificationScoreCreator();
        final context = MockDefaultIndividualClassificationScoreCreatingContext();
        const country = Country.emptyNone();
        final jumper = JumperDbRecord.empty(country: country)
            .copyWith(name: 'Jakub', surname: 'Wolny');
        final classification = MockDefaultClassification<JumperDbRecord,
            Standings<JumperDbRecord, ClassificationScoreDetails>>();
        final scores = [
          MockScore<JumperDbRecord, CompetitionJumperScoreDetails>(),
          MockScore<JumperDbRecord, CompetitionJumperScoreDetails>(),
          MockScore<JumperDbRecord, CompetitionJumperScoreDetails>(),
          MockScore<JumperDbRecord, CompetitionJumperScoreDetails>(),
        ].cast<Score<JumperDbRecord, CompetitionJumperScoreDetails>>();

        List<Competition<JumperDbRecord, IndividualCompetitionStandings>> competitions = [
          setupCompetition(jumper, scores[0], 2),
          setupCompetition(jumper, scores[1], 7),
          setupCompetition(jumper, scores[2], 5),
          setupCompetition(jumper, scores[3], 2),
        ];

        final classificationRules = MockDefaultIndividualClassificationRules();
        when(classificationRules.classificationScoreCreator).thenReturn(creator);
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
            .thenReturn(DefaultClassificationScoringType.pointsFromMap);
        when(classification.rules).thenReturn(classificationRules);
        when(context.entity).thenReturn(jumper);
        when(context.classification).thenReturn(classification);

        final score = creator.compute(context);

        expect(
          score,
          ClassificationScore<JumperDbRecord>(
            entity: jumper,
            points: 105.0,
            details: ClassificationScoreDetails(
              competitionScores: scores,
            ),
          ),
        );
      });
    });
  });
}

MockCompetition<JumperDbRecord, IndividualCompetitionStandings> setupCompetition(
  JumperDbRecord jumper,
  Score<JumperDbRecord, CompetitionJumperScoreDetails> score,
  int position,
) {
  final competition = MockCompetition<JumperDbRecord, IndividualCompetitionStandings>();
  final standings = MockStandings<JumperDbRecord, CompetitionJumperScoreDetails>();
  when(standings.scoreOf(jumper)).thenReturn(score);
  when(standings.positionOf(jumper)).thenReturn(position);
  when(competition.standings).thenReturn(standings);
  when(competition.rules).thenReturn(MockDefaultCompetitionRules());
  when(competition.labels).thenReturn([CompetitionPlayedStatus.played]);
  return competition;
}
