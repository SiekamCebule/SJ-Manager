import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/get_simulation_action_deadlines_map_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/get_simulation_actions_completion_map_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/get_sorted_incompleted_simulation_actions_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/usecases/get_simulation_current_date_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/simulation_flow/domain/usecases/continue_simulation_use_case.dart';

class SimulationCubit extends Cubit<SimulationState> {
  SimulationCubit({
    required this.getDate,
    required this.continueSimulationUseCase,
    required this.getPendingActions,
    required this.getActionsCompletionUseCase,
    required this.getActionDeadlinesMapUseCase,
  }) : super(const SimulationInitial());

  final GetSimulationCurrentDateUseCase getDate;
  final ContinueSimulationUseCase continueSimulationUseCase;
  final GetSortedIncompletedSimulationActionsUseCase getPendingActions;
  final GetSimulationActionsCompletionMapUseCase getActionsCompletionUseCase;
  final GetSimulationActionDeadlinesMapUseCase getActionDeadlinesMapUseCase;

  Future<void> advance(Duration duration) async {
    var state = this.state;
    if (state is! SimulationDefault) {
      throw StateError(
          'Cannot advance the simulation because simulation\'s state isn\'t SimulationDefault');
    }
    emit(state._toAdvanceInProgress());
    await continueSimulationUseCase();
    emit(SimulationDefault(
      currentDate: await getDate(),
      pendingActions: await getPendingActions(),
      actionIsCompleted: await getActionsCompletionUseCase(),
      actionDeadline: await getActionDeadlinesMapUseCase(),
    ));
  }
}

abstract class SimulationState extends Equatable {
  const SimulationState();

  @override
  List<Object?> get props => [];
}

class SimulationInitial extends SimulationState {
  const SimulationInitial();
}

abstract class SimulationInitialized extends SimulationState {
  const SimulationInitialized({
    required this.currentDate,
    required this.pendingActions,
    required this.actionIsCompleted,
    required this.actionDeadline,
  });

  final DateTime currentDate;
  final Iterable<SimulationAction> pendingActions;
  final Map<SimulationActionType, bool> actionIsCompleted;
  final Map<SimulationActionType, DateTime?> actionDeadline;

  @override
  List<Object?> get props => [
        currentDate,
        pendingActions,
        actionIsCompleted,
        actionDeadline,
      ];
}

class SimulationDefault extends SimulationInitialized {
  const SimulationDefault({
    required super.currentDate,
    required super.pendingActions,
    required super.actionIsCompleted,
    required super.actionDeadline,
  });

  SimulationAdvanceInProgress _toAdvanceInProgress() {
    return SimulationAdvanceInProgress(
      currentDate: currentDate,
      pendingActions: pendingActions,
      actionIsCompleted: actionIsCompleted,
      actionDeadline: actionDeadline,
    );
  }
}

class SimulationAdvanceInProgress extends SimulationInitialized {
  const SimulationAdvanceInProgress({
    required super.currentDate,
    required super.pendingActions,
    required super.actionIsCompleted,
    required super.actionDeadline,
  });
}
