import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class SetJumperTrainingBalanceUseCase {
  SetJumperTrainingBalanceUseCase();

  Future<void> call({
    required SimulationJumper jumper,
    required JumperTrainingCategory category,
    required double balance,
  }) async {
    jumper.trainingConfig!.balance[category] = balance;
  }
}
