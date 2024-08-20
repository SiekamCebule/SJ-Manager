import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/running/competition_scores_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';

class CompetitionResultsCubit<E> extends Cubit<CompetitionResultsState<E>> {
  CompetitionResultsCubit({
    required this.standings,
    required this.scoresCreator,
  }) : super(CompetitionResultsState(standings: standings));

  final Standings<E> standings;
  final CompetitionScoresCreator<E> scoresCreator;

  void registerJump({
    required E entity,
    required JumpSimulationRecord jumpSimulationRecord,
  }) {
    final jumpScore = scoresCreator.createJumpScore(jumpSimulationRecord);
    final entityCurrentScore = standings.scoreOf(entity) as CompetitionScore<E>?;
    final competitionScore = scoresCreator.createCompetitionScore(
        previous: entityCurrentScore, jumpScore: jumpScore);
    standings.addScore(newScore: competitionScore, overwrite: true);
  }
}

class CompetitionResultsState<E> with EquatableMixin {
  const CompetitionResultsState({required this.standings});

  final Standings<E> standings;

  @override
  List<Object?> get props => [standings];
}
