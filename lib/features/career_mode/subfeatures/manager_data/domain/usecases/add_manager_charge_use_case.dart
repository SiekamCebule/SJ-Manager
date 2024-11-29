import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class AddManagerChargeUseCase {
  const AddManagerChargeUseCase({
    required this.managerDataRepository,
  });

  final SimulationManagerDataRepository managerDataRepository;

  Future<void> call(SimulationJumper charge) async {
    final managerData = await managerDataRepository.get();
    managerData.personalCoachTeam!.jumpers.add(charge);
  }
}
