import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/usecases/training_flow/simulate_jumper_training_use_case.dart';

class SimulateGlobalTrainingUseCase {
  SimulateGlobalTrainingUseCase({
    required this.jumpersRepository,
    required this.simulateJumperTraining,
  });

  final SimulationJumpersRepository jumpersRepository;
  final SimulateJumperTrainingUseCase simulateJumperTraining;

  Future<void> call() async {
    for (var jumper in await jumpersRepository.getAll()) {
      await simulateJumperTraining(jumper);
    }
  }
}
