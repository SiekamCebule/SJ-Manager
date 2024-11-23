import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulations_repository.dart';

class GetAllSimulationsUseCase {
  const GetAllSimulationsUseCase({
    required this.simulationsRepository,
  });

  final SimulationsRepository simulationsRepository;

  Future<List<SjmSimulation>> call() async {
    return await simulationsRepository.getAll();
  }
}
