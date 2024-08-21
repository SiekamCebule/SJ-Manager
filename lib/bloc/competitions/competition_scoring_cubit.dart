import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';

class CompetitionScoringCubit<E, SJS extends SingleJumpScore>
    extends Cubit<CompetitionScoringState> {
  CompetitionScoringCubit({
    required this.jumpScoreCreator,
    required this.competitionScoreCreator,
  }) : super(const CompetitionScoringEmpty());

  final JumpScoreCreator jumpScoreCreator;
  final CompetitionScoreCreator<CompetitionScore<E, SJS>> competitionScoreCreator;

  void calculateScore(
      {required JumpSimulationRecord jumpSimulationRecord,
      required JumpScoreCreatingContext jumpScoreCreatingContext,
      required CompetitionScoreCreatingContext competitionScoreCreatingContext}) {
    final jumpScore = jumpScoreCreator.compute(jumpScoreCreatingContext);
    final competitionScore =
        competitionScoreCreator.compute(competitionScoreCreatingContext);
    emit(
      CompetitionScoringNonEmpty(
        lastSingleJumpScore: jumpScore,
        lastCompetitionScore: competitionScore,
      ),
    );
  }
}

abstract class CompetitionScoringState with EquatableMixin {
  const CompetitionScoringState();
}

class CompetitionScoringNonEmpty<S extends CompetitionScore>
    extends CompetitionScoringState {
  const CompetitionScoringNonEmpty({
    required this.lastSingleJumpScore,
    required this.lastCompetitionScore,
  });

  final SingleJumpScore lastSingleJumpScore;
  final S lastCompetitionScore;

  @override
  List<Object?> get props => [
        lastSingleJumpScore,
        lastCompetitionScore,
      ];
}

class CompetitionScoringEmpty extends CompetitionScoringState {
  const CompetitionScoringEmpty();

  @override
  List<Object?> get props => [];
}
