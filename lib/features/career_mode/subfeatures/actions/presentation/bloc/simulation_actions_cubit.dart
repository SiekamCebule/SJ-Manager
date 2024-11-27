import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/check_if_simulation_action_is_completed_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/complete_simulation_action_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/get_all_simulation_actions_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/get_sorted_incompleted_simulation_actions_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/get_simulation_action_deadlines_map_use_case.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/usecases/get_simulation_actions_completion_map_use_case.dart';

class SimulationActionsCubit extends Cubit<SimulationActionsState> {
  SimulationActionsCubit({
    required this.completeAction,
    required this.checkIfActionIsCompleted,
    required this.getAllActions,
    required this.getSortedIncompletedActions,
    required this.getCompletionMap,
    required this.getDeadlinesMap,
  }) : super(const SimulationActionsInitial());

  final CompleteSimulationActionUseCase completeAction;
  final CheckIfSimulationActionIsCompletedUseCase checkIfActionIsCompleted;
  final GetAllSimulationActionsUseCase getAllActions;
  final GetSortedIncompletedSimulationActionsUseCase getSortedIncompletedActions;
  final GetSimulationActionsCompletionMapUseCase getCompletionMap;
  final GetSimulationActionDeadlinesMapUseCase getDeadlinesMap;

  Future<void> initialize() async {
    emit(SimulationActionsDefault(
      actions: await getAllActions(),
      sortedIncompletedActions: await getSortedIncompletedActions(),
      deadline: await getDeadlinesMap(),
      isCompleted: await getCompletionMap(),
    ));
  }

  Future<void> complete(SimulationActionType actionType) async {
    await completeAction(actionType);
    emit(SimulationActionsDefault(
      actions: await getAllActions(),
      sortedIncompletedActions: await getSortedIncompletedActions(),
      deadline: await getDeadlinesMap(),
      isCompleted: await getCompletionMap(),
    ));
  }
}

abstract class SimulationActionsState extends Equatable {
  const SimulationActionsState();

  @override
  List<Object?> get props => [];
}

class SimulationActionsInitial extends SimulationActionsState {
  const SimulationActionsInitial();
}

class SimulationActionsDefault extends SimulationActionsState {
  const SimulationActionsDefault({
    required this.actions,
    required this.sortedIncompletedActions,
    required this.isCompleted,
    required this.deadline,
  });

  final Iterable<SimulationAction> actions;
  final Iterable<SimulationAction> sortedIncompletedActions;
  final Map<SimulationActionType, bool> isCompleted;
  final Map<SimulationActionType, DateTime?> deadline;

  @override
  List<Object?> get props => [
        isCompleted,
      ];
}
