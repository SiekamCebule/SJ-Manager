import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/models/simulation/standings/score/score.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:collection/collection.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class DefaultLinearTeamCompetitionScoreCreator extends CompetitionScoreCreator<
    Score<CompetitionTeam<Team>, CompetitionTeamScoreDetails>> {
  @override
  Score<CompetitionTeam, CompetitionTeamScoreDetails> compute(
      covariant TeamCompetitionScoreCreatingContext context) {
    if (context.currentScore == null) {
      return Score<CompetitionTeam, CompetitionTeamScoreDetails>(
        entity: context.entity,
        points: context.lastJumpScore.points,
        details: CompetitionTeamScoreDetails(
          jumperScores: [
            Score<Jumper, CompetitionJumperScoreDetails>(
              entity: context.lastJumpScore.entity,
              points: context.lastJumpScore.points,
              details: CompetitionJumperScoreDetails(
                jumpScores: [context.lastJumpScore],
              ),
            ),
          ],
        ),
      );
    } else {
      final currentScore =
          context.currentScore! as Score<CompetitionTeam, CompetitionTeamScoreDetails>;
      final currentJumperScores = currentScore.details.jumperScores;
      final updatedJumperScores = currentJumperScores.map((jumperScore) {
        if (jumperScore.entity == context.lastJumpScore.entity) {
          return Score<Jumper, CompetitionJumperScoreDetails>(
            entity: jumperScore.entity,
            points: jumperScore.points + context.lastJumpScore.points,
            details: CompetitionJumperScoreDetails(
              jumpScores: [
                ...jumperScore.details.jumpScores,
                context.lastJumpScore,
              ],
            ),
          );
        } else {
          return jumperScore;
        }
      }).toList();
      final jumperHaveScore = updatedJumperScores.singleWhereOrNull(
              (jumperScore) => jumperScore.entity == context.lastJumpScore.entity) !=
          null;
      if (!jumperHaveScore) {
        updatedJumperScores.add(
          Score<Jumper, CompetitionJumperScoreDetails>(
            entity: context.lastJumpScore.entity,
            points: context.lastJumpScore.points,
            details: CompetitionJumperScoreDetails(
              jumpScores: [context.lastJumpScore],
            ),
          ),
        );
      }
      return Score<CompetitionTeam, CompetitionTeamScoreDetails>(
        entity: context.entity,
        points: context.currentScore!.points + context.lastJumpScore.points,
        details: CompetitionTeamScoreDetails(
          jumperScores: updatedJumperScores,
        ),
      );
    }
  }
}
