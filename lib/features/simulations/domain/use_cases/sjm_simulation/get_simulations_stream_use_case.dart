import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/features/simulations/domain/repository/simulations_repository.dart';

class GetSimulationsStreamUseCase {
  const GetSimulationsStreamUseCase({
    required this.simulationsRepository,
  });

  final SimulationsRepository simulationsRepository;

  Future<Stream<List<SjmSimulation>>> call() async {
    return await simulationsRepository.stream;
  }
}
