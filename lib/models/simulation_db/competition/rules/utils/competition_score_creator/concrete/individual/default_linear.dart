import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';

class DefaultLinearIndividualCompetitionScoreCreator
    extends CompetitionScoreCreator<CompetitionJumperScore> {
  @override
  CompetitionJumperScore compute(
      covariant IndividualCompetitionScoreCreatingContext context) {
    if (context.currentCompetitionScore == null) {
      return CompetitionJumperScore(
        entity: context.entity,
        points: context.lastJumpScore.points,
        jumpScores: [context.lastJumpScore],
      );
    } else {
      return CompetitionJumperScore(
        entity: context.entity,
        points: context.currentCompetitionScore!.points,
        jumpScores: [
          ...context.currentCompetitionScore!.jumpScores,
          context.lastJumpScore,
        ],
      );
    }
  }
}
