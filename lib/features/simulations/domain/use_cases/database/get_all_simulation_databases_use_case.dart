import 'package:sj_manager/features/simulations/domain/repository/simulation_databases_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

class GetAllSimulationDatabasesUseCase {
  const GetAllSimulationDatabasesUseCase({
    required this.databasesRepository,
  });

  final SimulationDatabasesRepository databasesRepository;

  Future<Map<String, SimulationDatabase>> call() async {
    return await databasesRepository.getAll();
  }
}
