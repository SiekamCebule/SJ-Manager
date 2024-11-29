import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class GetJumperTrainingBalanceForAllCategoriesUseCase {
  GetJumperTrainingBalanceForAllCategoriesUseCase();

  Future<Map<JumperTrainingCategory, double>> call({
    required SimulationJumper jumper,
  }) async {
    return jumper.trainingConfig!.balance;
  }
}
