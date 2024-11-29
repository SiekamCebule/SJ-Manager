import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class SetJumperTrainingConfigUseCase {
  SetJumperTrainingConfigUseCase();

  Future<void> call({
    required SimulationJumper jumper,
    required JumperTrainingConfig trainingConfig,
  }) async {
    jumper.trainingConfig = trainingConfig;
  }
}
