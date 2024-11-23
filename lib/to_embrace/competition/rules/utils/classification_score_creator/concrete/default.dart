import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/to_embrace/competition/competition_labels.dart';
import 'package:sj_manager/to_embrace/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/typedefs.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';

abstract class DefaultClassificationScoreCreator<E,
        C extends DefaultClassificationScoreCreatingContext<E>>
    extends ClassificationScoreCreator<E, C> {
  late C context;
  var significantCompetitions = <Competition>[];
  var competitionScores = <CompetitionScore>[];
  double points = 0;

  @override
  ClassificationScore<E> compute(C input) {
    setUpContext(input);
    clearData();
    setUpSignificantCompetitions();
    validateSignificantCompetitions();
    setUpCompetitionScores();
    calculatePoints();
    return constructScore();
  }

  void setUpContext(C context) {
    this.context = context;
  }

  void clearData() {
    points = 0;
    significantCompetitions = [];
    competitionScores = [];
  }

  void setUpSignificantCompetitions() {
    significantCompetitions.clear();
    for (final competition in context.classification.rules.competitions) {
      if (competition is Competition<JumperDbRecord, IndividualCompetitionStandings>) {
        if (competition.labels.contains(CompetitionPlayedStatus.played)) {
          significantCompetitions.add(competition);
        }
      }
    }
  }

  void validateSignificantCompetitions() {
    for (final competition in significantCompetitions) {
      if (competition.labels.contains(CompetitionPlayedStatus.nonPlayed) &&
          competition.standings != null) {
        throw _competitionIsPlayedButDoesntHaveStandingsError(competition: competition);
      }
    }
  }

  Error _competitionIsPlayedButDoesntHaveStandingsError(
      {required Competition competition}) {
    return StateError(
      'The competition ($competition) is marked as played (its labels set contains CompetitionPlayedStatus.played), but the standings object is null',
    );
  }

  void setUpCompetitionScores();

  void calculatePoints();

  ClassificationScore<E> constructScore() {
    return ClassificationScore<E>(
      entity: context.entity,
      points: points,
      details: ClassificationScoreDetails(
        competitionScores: competitionScores,
      ),
    );
  }
}
