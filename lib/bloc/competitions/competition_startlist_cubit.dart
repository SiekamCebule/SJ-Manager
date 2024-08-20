import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/running/competition_start_list_repository.dart';

class CompetitionStartlistCubit<E> extends Cubit<CompetitionStartlistState> {
  CompetitionStartlistCubit({
    required this.startlist,
  }) : super(
          CompetitionStartlistState(startlist: startlist),
        );

  CompetitionStartlistRepo<E> startlist;

  void complete(E entity) {
    startlist.complete(entity);
    emit(CompetitionStartlistState(startlist: startlist));
  }

  void updateStartlist(CompetitionStartlistRepo<E> newStartlist) {
    emit(CompetitionStartlistState(startlist: newStartlist));
  }
}

class CompetitionStartlistState<E> with EquatableMixin {
  const CompetitionStartlistState({required this.startlist});

  final CompetitionStartlistRepo<E> startlist;
  E get currentEntity => startlist.firstIncompleted;

  @override
  List<Object?> get props => [
        startlist,
      ];
}
