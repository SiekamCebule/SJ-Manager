import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';

class GetManagerTeamUseCase {
  const GetManagerTeamUseCase({
    required this.managerDataRepository,
  });

  final SimulationManagerDataRepository managerDataRepository;

  Future<SimulationTeam?> call() async {
    final managerData = await managerDataRepository.get();
    return switch (managerData.mode) {
      SimulationMode.classicCoach => managerData.userSubteam,
      SimulationMode.personalCoach => managerData.personalCoachTeam,
      SimulationMode.observer => throw StateError('An observer cannot have a team'),
    };
  }
}
