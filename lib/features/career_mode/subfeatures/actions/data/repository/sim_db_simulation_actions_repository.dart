import 'package:sj_manager/features/career_mode/subfeatures/actions/data/data_sources/sim_db_simulation_actions_data_source.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';

class SimDbSimulationActionsRepository implements SimulationActionsRepository {
  SimDbSimulationActionsRepository({
    required this.dataSource,
  });

  final SimDbSimulationActionsDataSource dataSource;

  @override
  Future<void> complete(SimulationActionType actionType) async {
    await dataSource.complete(actionType);
  }

  @override
  Future<bool> isCompleted(SimulationActionType actionType) async {
    return await dataSource.isCompleted(actionType);
  }

  @override
  Future<Map<SimulationActionType, bool>> getCompletionMap() async {
    return await dataSource.getCompletionMap();
  }

  @override
  Future<Iterable<SimulationAction>> getAll() async {
    return await dataSource.getAll();
  }
}
