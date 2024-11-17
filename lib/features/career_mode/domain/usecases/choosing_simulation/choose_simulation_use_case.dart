import 'package:sj_manager/features/career_mode/domain/entities/simulation.dart';
import 'package:sj_manager/features/career_mode/domain/repository/simulation_databases_repository.dart';
import 'package:sj_manager/features/career_mode/domain/repository/simulations_repository.dart';

class ChooseSimulationUseCase {
  const ChooseSimulationUseCase({
    required this.databasesRepository,
    required this.simulationsRepository,
  });

  final SimulationDatabasesRepository databasesRepository;
  final SimulationsRepository simulationsRepository;

  Future<Simulation> call(Simulation simulation) async {
    final database = await databasesRepository.getDatabase(simulation.id);
    return simulation.copyWith(database: database);
  }
}
