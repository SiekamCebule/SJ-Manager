import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/running/competition_start_list_repository.dart';

class CompetitionStartlistCubit<E> extends Cubit<CompetitionStartlistUnfinished> {
  CompetitionStartlistCubit({
    required this.startlist,
  }) : super(
          CompetitionStartlistUnfinished(startlist: startlist),
        );

  CompetitionStartlistRepo<E> startlist;

  void complete(E entity) {
    startlist.complete(entity);
    emit(CompetitionStartlistUnfinished(startlist: startlist));
  }

  void updateStartlist(CompetitionStartlistRepo<E> newStartlist) {
    emit(CompetitionStartlistUnfinished(startlist: newStartlist));
  }
}

abstract class CompetitionStartlistState<E> with EquatableMixin {
  const CompetitionStartlistState({
    required this.startlist,
  });

  final CompetitionStartlistRepo<E> startlist;

  @override
  List<Object?> get props => [];
}

class CompetitionStartlistUnfinished<E> extends CompetitionStartlistState<E> {
  const CompetitionStartlistUnfinished({required super.startlist});

  E get currentEntity => startlist.firstIncompleted!;
  int get currentEntityIndexInStartlist {
    return startlist.indexOf(currentEntity);
  }

  E? get nextEntity => startlist.atNFromIncompleted(2);

  @override
  List<Object?> get props => [
        startlist,
      ];
}

class CompetitionStartlistFinished<E> extends CompetitionStartlistState<E> {
  const CompetitionStartlistFinished({required super.startlist});
}
