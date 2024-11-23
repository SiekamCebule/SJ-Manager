import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

abstract interface class SimulationDatabasesRepository {
  Future<SimulationDatabase> get(String simulationId);
  Future<Map<String, SimulationDatabase>> getAll();
  Future<void> preserve(SimulationDatabase database, {required String simulationId});
  Future<void> delete(String simulationId);
}
