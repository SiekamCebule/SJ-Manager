import 'package:sj_manager/features/simulations/domain/repository/simulations_repository.dart';

class LoadAllSimulationsUseCase {
  const LoadAllSimulationsUseCase({
    required this.simulationsRepository,
  });

  final SimulationsRepository simulationsRepository;

  Future<void> call() async {
    await simulationsRepository.loadAll();
  }
}
