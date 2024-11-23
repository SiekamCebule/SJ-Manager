import 'package:sj_manager/features/simulations/domain/repository/simulation_databases_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';

class GetSimulationDatabaseUseCase {
  const GetSimulationDatabaseUseCase({
    required this.databasesRepository,
  });

  final SimulationDatabasesRepository databasesRepository;

  Future<SimulationDatabase> call(String id) async {
    return await databasesRepository.get(id);
  }
}
