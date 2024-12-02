import 'package:sj_manager/features/competitions/domain/entities/scoring/score/competition_scores.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/context/competition_score_creating_context.dart';
import 'package:sj_manager/features/competitions/domain/utils/competition_score_creator/specific/individual/individual_competition_score_creator.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class DefaultLinearIndividualCompetitionScoreCreator
    implements IndividualCompetitionScoreCreator {
  @override
  CompetitionScore<SimulationJumper> create(
      covariant IndividualCompetitionScoreCreatingContext context) {
    if (context.currentScore == null) {
      return CompetitionJumperScore(
        subject: context.subject,
        points: context.lastJumpScore.points,
        jumps: [context.lastJumpScore],
        competition: context.competition,
      );
    } else {
      final currentScore = context.currentScore as CompetitionJumperScore;
      return CompetitionJumperScore(
        subject: context.subject,
        points: context.currentScore!.points + context.lastJumpScore.points,
        jumps: [
          ...currentScore.jumps,
          context.lastJumpScore,
        ],
        competition: context.competition,
      );
    }
  }
}
