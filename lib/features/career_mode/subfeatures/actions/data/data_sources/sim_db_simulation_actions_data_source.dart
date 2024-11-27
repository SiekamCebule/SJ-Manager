import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

abstract interface class SimDbSimulationActionsDataSource {
  Future<void> complete(SimulationActionType actionType);
  Future<bool> isCompleted(SimulationActionType actionType);
  Future<Map<SimulationActionType, bool>> getCompletionMap();
  Future<Iterable<SimulationAction>> getAll();
}

class SimDbSimulationActionsDataSourceImpl implements SimDbSimulationActionsDataSource {
  SimDbSimulationActionsDataSourceImpl({
    required this.database,
  });

  final SimulationDatabase database;

  @override
  Future<void> complete(SimulationActionType actionType) async {
    final action = database.actions.singleWhere((action) => action.type == actionType);
    action.isCompleted = true;
  }

  @override
  Future<bool> isCompleted(SimulationActionType actionType) async {
    final action = database.actions.singleWhere((action) => action.type == actionType);
    return action.isCompleted;
  }

  @override
  Future<Map<SimulationActionType, bool>> getCompletionMap() async {
    return {
      for (var action in database.actions) action.type: action.isCompleted,
    };
  }

  @override
  Future<Iterable<SimulationAction>> getAll() async {
    return database.actions;
  }
}
