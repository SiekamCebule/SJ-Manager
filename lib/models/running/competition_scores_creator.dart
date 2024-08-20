import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';

abstract interface class CompetitionScoresCreator<E> {
  const CompetitionScoresCreator();

  SingleJumpScore<E> createJumpScore(JumpSimulationRecord jumpSimulationRecord);
  CompetitionScore<E> createCompetitionScore(
      {required CompetitionScore<E>? previous, required SingleJumpScore<E> jumpScore});
}
