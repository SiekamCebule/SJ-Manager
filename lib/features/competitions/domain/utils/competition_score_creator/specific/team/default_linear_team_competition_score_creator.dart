import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/context/competition_score_creating_context.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/specific/team/team_competition_score_creator.dart';

class DefaultLinearTeamCompetitionScoreCreator implements TeamCompetitionScoreCreator {
  @override
  CompetitionTeamScore create(covariant TeamCompetitionScoreCreatingContext context) {
    if (context.currentScore == null) {
      return _createFirstScore(context);
    } else {
      return _createSubsequent(context);
    }
  }

  CompetitionTeamScore _createFirstScore(TeamCompetitionScoreCreatingContext context) {
    return CompetitionTeamScore(
      subject: context.subject,
      points: context.lastJumpScore.points,
      subscores: [
        CompetitionJumperScore(
          subject: context.lastJumpScore.subject,
          points: context.lastJumpScore.points,
          jumps: [context.lastJumpScore],
          competition: context.competition,
        ),
      ],
      competition: context.competition,
    );
  }

  CompetitionTeamScore _createSubsequent(TeamCompetitionScoreCreatingContext context) {
    final currentScore = context.currentScore! as CompetitionTeamScore;
    final updatedJumperScores = currentScore.subscores.map((uncastedJumperScore) {
      final jumperScore = uncastedJumperScore as CompetitionJumperScore;
      if (jumperScore.subject == context.lastJumpScore.subject) {
        return CompetitionJumperScore(
          subject: jumperScore.subject,
          points: jumperScore.points + context.lastJumpScore.points,
          jumps: [
            ...jumperScore.jumps,
            context.lastJumpScore,
          ],
          competition: context.competition,
        );
      } else {
        return jumperScore;
      }
    }).toList();
    final jumperHasScore = updatedJumperScores
        .any((jumperScore) => jumperScore.subject == context.lastJumpScore.subject);
    if (!jumperHasScore) {
      updatedJumperScores.add(
        CompetitionJumperScore(
          subject: context.lastJumpScore.subject,
          points: context.lastJumpScore.points,
          jumps: [context.lastJumpScore],
          competition: context.competition,
        ),
      );
    }
    return CompetitionTeamScore(
      subject: context.subject,
      points: context.currentScore!.points + context.lastJumpScore.points,
      subscores: updatedJumperScores,
      competition: context.competition,
    );
  }
}
