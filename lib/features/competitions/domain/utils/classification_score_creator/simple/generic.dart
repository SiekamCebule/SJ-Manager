import 'package:sj_manager/features/competitions/domain/entities/scoring/score/classification_scores.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/classification_score_creator.dart';
import 'package:sj_manager/features/competitions/domain/utils/classification_score_creator/context/simple_classification_score_creating_context.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';

abstract class SimpleClassificationScoreCreator<T, S extends ClassificationScore<T>,
        C extends SimpleClassificationScoreCreatingContext<T>>
    implements ClassificationScoreCreator<T> {
  late C context;
  var significantCompetitions = <Competition>[];
  var competitionScores = <CompetitionScore>[];
  double points = 0;

  @override
  S create(covariant C context) {
    setUpContext(context);
    clearData();
    determineSignificantCompetitions();
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

  void determineSignificantCompetitions();
  void setUpCompetitionScores();
  void calculatePoints();
  S constructScore();
}
