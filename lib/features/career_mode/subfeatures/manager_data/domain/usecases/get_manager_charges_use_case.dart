import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';

class GetManagerChargesUseCase {
  const GetManagerChargesUseCase({
    required this.managerDataRepository,
  });

  final SimulationManagerDataRepository managerDataRepository;

  Future<Iterable<SimulationJumper>> call() async {
    final managerData = await managerDataRepository.get();
    return switch (managerData.mode) {
      SimulationMode.classicCoach => managerData.userSubteam!.jumpers,
      SimulationMode.personalCoach => managerData.personalCoachTeam!.jumpers,
      SimulationMode.observer => throw StateError('An observer cannot have charges'),
    };
  }
}
