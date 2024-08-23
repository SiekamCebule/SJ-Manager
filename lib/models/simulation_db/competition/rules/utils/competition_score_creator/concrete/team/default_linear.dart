import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';

class DefaultLinearTeamCompetitionScoreCreator
    extends CompetitionScoreCreator<CompetitionTeamScore<CompetitionTeam>> {
  @override
  CompetitionTeamScore<CompetitionTeam> compute(
      covariant TeamCompetitionScoreCreatingContext context) {
    if (context.currentScore == null) {
      return CompetitionTeamScore<CompetitionTeam>(
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
      final currentScore = context.currentScore! as CompetitionTeamScore;
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
        points: context.currentScore!.points + context.lastJumpScore.points,
        jumperScores: updatedJumperScores,
      );
    }
  }
}
