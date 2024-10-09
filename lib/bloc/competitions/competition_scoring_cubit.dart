import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/competition_score_creator/competition_score_creator.dart';
import 'package:sj_manager/models/simulation/competition/rules/utils/jump_score_creator/jump_score_creator.dart';
import 'package:sj_manager/models/simulation/standings/score/typedefs.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class CompetitionScoringCubit<E> extends Cubit<CompetitionScoringState> {
  CompetitionScoringCubit({
    required this.jumpScoreCreator,
    required this.competitionScoreCreator,
  }) : super(const CompetitionScoringEmpty());

  final JumpScoreCreator<Jumper> jumpScoreCreator;
  final CompetitionScoreCreator<CompetitionScore<E>> competitionScoreCreator;

  void calculateScore({
    required JumpSimulationRecord jumpSimulationRecord,
    required JumpScoreCreatingContext<Jumper> jumpScoreCreatingContext,
    required CompetitionScoreCreatingContext<E> competitionScoreCreatingContext,
  }) {
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

  final CompetitionJumpScore lastSingleJumpScore;
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
