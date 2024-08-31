import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/competition/competition_labels.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/score/details/classification_score_details.dart';
import 'package:sj_manager/models/simulation_db/standings/score/typedefs.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

abstract class DefaultClassificationScoreCreator<E,
        C extends DefaultClassificationScoreCreatingContext<E>>
    extends ClassificationScoreCreator<E, C> {
  late C context;
  var significantCompetitions = <Competition>[];
  var competitionScores = <CompetitionScore>[];
  double points = 0;

  @override
  ClassificationScore<E> compute(C input) {
    setUpContext(context);
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
      if (competition is Competition<Jumper, IndividualCompetitionStandings>) {
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
