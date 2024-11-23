import 'package:equatable/equatable.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/actions/simulation_action_type.dart';

class SimulationActionsRepo with EquatableMixin {
  SimulationActionsRepo({
    Set<SimulationActionType>? initial,
  }) {
    _completedActions = initial ?? {};
  }

  late final Set<SimulationActionType> _completedActions;

  Set<SimulationActionType> get completedActions => _completedActions;

  void complete(SimulationActionType action) {
    _completedActions.add(action);
  }

  void markAsIncompleted(SimulationActionType action) {
    _completedActions.remove(action);
  }

  void reset() {
    _completedActions.clear();
  }

  bool isCompleted(SimulationActionType action) {
    return _completedActions.contains(action);
  }

  bool isNotCompleted(SimulationActionType action) => !isCompleted(action);

  @override
  List<Object?> get props => [
        _completedActions,
      ];
}
