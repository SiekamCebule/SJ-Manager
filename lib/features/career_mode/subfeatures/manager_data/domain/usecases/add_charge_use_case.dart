import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class AddTraineeUseCase {
  const AddTraineeUseCase({
    required this.managerDataRepository,
  });

  final SimulationManagerDataRepository managerDataRepository;

  Future<void> call(SimulationJumper trainee) async {
    final managerData = await managerDataRepository.get();
    managerData.personalCoachTeam!.jumpers.add(trainee);
  }
}
