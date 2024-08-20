import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/competitions/states/competition_status_state.dart';

import 'package:sj_manager/models/running/competition_flow_controller.dart';
import 'package:sj_manager/models/running/competition_status.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class CompetitionStatusCubit<E> extends Cubit<CompetitionStatusState> {
  CompetitionStatusCubit({
    required this.flowController,
  }) : super(_resolveInitial<E>());

  CompetitionFlowController<E> flowController;

  static CompetitionStatusState _resolveInitial<E>() {
    if (E is Jumper) {
      return const IndividualCompetitionStatusState(
          status: CompetitionStatus.nonStarted, roundIndex: 0);
    } else if (E is Team) {
      return const TeamCompetitionStatusState(
        status: CompetitionStatus.nonStarted,
        roundIndex: 0,
        groupIndex: 0,
      );
    } else {
      throw UnsupportedError(
          'Unsupported entities type in CompetitionStatusCubit\'s initial work');
    }
  }

  void ensureByFlowController() {
    if (flowController.shouldEndCompetition()) {
      emit(state.copyWith(status: CompetitionStatus.endingEntirely));
    } else if (flowController.shouldEndRound()) {
      emit(state.copyWith(status: CompetitionStatus.endingRound));
    }
    if (flowController is TeamCompetitionFlowController) {
      final teamCompetitionFlowController =
          flowController as TeamCompetitionFlowController;
      if (teamCompetitionFlowController.shouldEndGroup()) {
        final currentState = state as TeamCompetitionStatusState;
        emit(currentState.concreteCopyWith(status: CompetitionStatus.endingGroup));
      }
    }
  }

  void goToNextRound() {
    emit(state.copyWith(roundIndex: state.roundIndex + 1));
  }

  void goToNextGroup() {
    if (state is TeamCompetitionStatusState == false) {
      throw UnsupportedError(
        'The entities type is not Team or Team\'s subclass, so cannot change the group index',
      );
    }
    final currentState = state as TeamCompetitionStatusState;
    emit(currentState.concreteCopyWith(groupIndex: currentState.groupIndex + 1));
  }
}
