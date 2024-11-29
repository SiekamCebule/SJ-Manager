import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class SetManagerChargesUseCase {
  const SetManagerChargesUseCase({
    required this.managerDataRepository,
  });

  final SimulationManagerDataRepository managerDataRepository;

  Future<void> call(Iterable<SimulationJumper> charges) async {
    final managerData = await managerDataRepository.get();
    managerData.personalCoachTeam!.jumpers = charges.toList();
  }
}
