import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/data/models/simulation/standings/score/details/competition_score_details.dart';
import 'package:sj_manager/data/models/simulation/standings/score/typedefs.dart';
import 'package:sj_manager/data/models/simulation/standings/standings.dart';

class CompetitionResultsCubit<E> extends Cubit<CompetitionResultsState<E>> {
  CompetitionResultsCubit({
    required this.standings,
  }) : super(CompetitionResultsState(standings: standings));

  final Standings<E, CompetitionScoreDetails> standings;

  void registerResult({
    required E entity,
    required CompetitionScore<E> score,
  }) {
    standings.addScore(newScore: score, overwrite: true);
  }
}

class CompetitionResultsState<E> with EquatableMixin {
  const CompetitionResultsState({required this.standings});

  final Standings<E, CompetitionScoreDetails> standings;

  @override
  List<Object?> get props => [standings];
}
