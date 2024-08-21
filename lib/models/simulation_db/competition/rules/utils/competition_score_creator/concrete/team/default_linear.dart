import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';

class DefaultLinearTeamCompetitionScoreCreator
    extends CompetitionScoreCreator<CompetitionTeamScore> {
  @override
  CompetitionTeamScore compute(covariant TeamCompetitionScoreCreatingContext context) {
    if (context.currentCompetitionScore == null) {
      return CompetitionTeamScore(
        entity: context.entity,
        points: context.lastJumpScore.points,
        jumperScores: [
          CompetitionJumperScore(
            entity: context.lastJumpScore.entity,
            points: context.lastJumpScore.points,
            jumpScores: [context.lastJumpScore],
          ),
        ],
      );
    } else {
      final currentScore = context.currentCompetitionScore! as CompetitionTeamScore;
      final currentJumperScores = currentScore.jumperScores;
      final updatedJumperScores = currentJumperScores.map((jumperScore) {
        if (jumperScore.entity == context.lastJumpScore.entity) {
          return CompetitionJumperScore(
            entity: jumperScore.entity,
            points: jumperScore.points + context.lastJumpScore.points,
            jumpScores: [
              ...jumperScore.jumpScores,
              context.lastJumpScore,
            ],
          );
        } else {
          return jumperScore;
        }
      }).toList();
      return CompetitionTeamScore(
        entity: context.entity,
        points: context.currentCompetitionScore!.points + context.lastJumpScore.points,
        jumperScores: updatedJumperScores,
      );
    }
  }
}
