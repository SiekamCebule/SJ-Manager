import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';

class GetSimulationModeUseCase {
  const GetSimulationModeUseCase({
    required this.managerDataRepository,
  });

  final SimulationManagerDataRepository managerDataRepository;

  Future<SimulationMode> call() async {
    final managerData = await managerDataRepository.get();
    return managerData.mode;
  }
}
