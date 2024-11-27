import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';

abstract interface class SimulationActionsRepository {
  Future<SimulationAction> actionByType(SimulationActionType actionType);
  Future<void> complete(SimulationActionType actionType);
  Future<bool> isCompleted(SimulationActionType actionType);
  Future<Map<SimulationActionType, bool>> getCompletionMap();
  Future<Iterable<SimulationAction>> getAll();
}
