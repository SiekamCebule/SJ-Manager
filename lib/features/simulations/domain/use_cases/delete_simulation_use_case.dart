import 'package:sj_manager/core/general_utils/file_system.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulation_databases_repository.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulations_repository.dart';

class DeleteSimulationUseCase {
  DeleteSimulationUseCase({
    required this.pathsCache,
    required this.simulationsRepository,
    required this.databasesRepository,
  });

  final PlarformSpecificPathsCache pathsCache;
  final SimulationsRepository simulationsRepository;
  final SimulationDatabasesRepository databasesRepository;

  Future<void> call(SjmSimulation simulation) async {
    await simulationsRepository.remove(simulation.id);
    await databasesRepository.delete(simulation.id);
  }
}
