import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulation_databases_repository.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulations_repository.dart';

class PreserveSimulationUseCase {
  const PreserveSimulationUseCase({
    required this.simulationsRepository,
    required this.databasesRepository,
  });

  final SimulationsRepository simulationsRepository;
  final SimulationDatabasesRepository databasesRepository;

  Future<void> call(SjmSimulation simulation) async {
    final database = await databasesRepository.get(simulation.id);
    await simulationsRepository.preserve(
      simulation,
      saveTime: DateTime.now(),
      mode: database.managerData.mode,
    );

    await databasesRepository.preserve(database, simulationId: simulation.id);
  }
}
