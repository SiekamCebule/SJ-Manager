import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/jump_score.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';

class CompetitionResultsCubit<E, SJS extends JumpScore>
    extends Cubit<CompetitionResultsState<E>> {
  CompetitionResultsCubit({
    required this.standings,
  }) : super(CompetitionResultsState(standings: standings));

  final Standings<E> standings;

  void registerResult({
    required E entity,
    required CompetitionScore<E, SJS> score,
  }) {
    standings.addScore(newScore: score, overwrite: true);
  }
}

class CompetitionResultsState<E> with EquatableMixin {
  const CompetitionResultsState({required this.standings});

  final Standings<E> standings;

  @override
  List<Object?> get props => [standings];
}
