import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';

abstract interface class SimulationDatabasesRepository {
  Future<SimulationDatabase> getDatabase(String simulationId);
  Future<void> saveDatabase(SimulationDatabase database);
}
