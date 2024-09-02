import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/models/running/competition_start_list_repository.dart';

class CompetitionStartlistCubit<E> extends Cubit<CompetitionStartlistState> {
  CompetitionStartlistCubit({
    required this.startlist,
  }) : super(CompetitionStartlistInitial<E>()) {
    emit(_createUnfinishedStartlistState());
  }

  CompetitionStartlistRepo<E> startlist;

  void complete(E entity) {
    startlist.complete(entity);
    if (startlist.everyHasCompleted) {
      emit(CompetitionStartlistFinished<E>());
    } else {
      emit(_createUnfinishedStartlistState());
    }
  }

  void updateStartlist(CompetitionStartlistRepo<E> newStartlist) {
    if (newStartlist.everyHasCompleted) {
      emit(CompetitionStartlistFinished<E>());
    } else {
      emit(_createUnfinishedStartlistState());
    }
  }

  CompetitionStartlistUnfinished<E> _createUnfinishedStartlistState() {
    return CompetitionStartlistUnfinished(
      currentEntity: startlist.incompleted.first! as E,
      nextEntity: startlist.incompleted.elementAtOrNull(1),
      currentEntityIndexInStartlist: startlist.indexOf(startlist.incompleted.first! as E),
      remainingEntities: startlist.incompleted,
    );
  }
}

abstract class CompetitionStartlistState<E> with EquatableMixin {
  const CompetitionStartlistState();

  @override
  List<Object?> get props => [];
}

class CompetitionStartlistInitial<E> extends CompetitionStartlistState {
  const CompetitionStartlistInitial();
}

class CompetitionStartlistUnfinished<E> extends CompetitionStartlistState<E> {
  const CompetitionStartlistUnfinished({
    required this.currentEntity,
    required this.nextEntity,
    required this.currentEntityIndexInStartlist,
    required this.remainingEntities,
  });

  final E currentEntity;
  final E? nextEntity;
  final int currentEntityIndexInStartlist;
  final List<E> remainingEntities;

  @override
  List<Object?> get props => [
        currentEntity,
        nextEntity,
        currentEntityIndexInStartlist,
        remainingEntities,
      ];
}

class CompetitionStartlistFinished<E> extends CompetitionStartlistState<E> {
  const CompetitionStartlistFinished();
}
