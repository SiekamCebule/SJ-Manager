import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/typedefs.dart';

class DefaultLinearIndividualCompetitionScoreCreator
    extends CompetitionScoreCreator<CompetitionJumperScore> {
  @override
  CompetitionJumperScore compute(
      covariant IndividualCompetitionScoreCreatingContext context) {
    if (context.currentScore == null) {
      return CompetitionJumperScore(
        entity: context.entity,
        points: context.lastJumpScore.points,
        details: CompetitionJumperScoreDetails(jumpScores: [context.lastJumpScore]),
      );
    } else {
      return CompetitionJumperScore(
          entity: context.entity,
          points: context.currentScore!.points + context.lastJumpScore.points,
          details: CompetitionJumperScoreDetails(
            jumpScores: [
              ...context.currentScore!.details.jumpScores,
              context.lastJumpScore,
            ],
          ));
    }
  }
}
