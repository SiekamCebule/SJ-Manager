import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulations_repository.dart';

class GetSimulationUseCase {
  const GetSimulationUseCase({
    required this.simulationsRepository,
  });

  final SimulationsRepository simulationsRepository;

  Future<SjmSimulation> call(String id) async {
    return await simulationsRepository.get(id);
  }
}
