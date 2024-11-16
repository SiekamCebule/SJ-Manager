import 'package:sj_manager/data/models/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/data/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/score/score.dart';
import 'package:sj_manager/data/models/database/jumper/jumper_db_record.dart';
import 'package:sj_manager/data/models/database/team/competition_team.dart';
import 'package:collection/collection.dart';
import 'package:sj_manager/data/models/database/team/team.dart';

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
            Score<JumperDbRecord, CompetitionJumperScoreDetails>(
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
          return Score<JumperDbRecord, CompetitionJumperScoreDetails>(
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
          Score<JumperDbRecord, CompetitionJumperScoreDetails>(
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
