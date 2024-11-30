import 'package:sj_manager/features/career_mode/subfeatures/manager_data/domain/repository/simulation_manager_data_repository.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class ReorderTraineesUseCase {
  const ReorderTraineesUseCase({
    required this.managerDataRepository,
  });

  final SimulationManagerDataRepository managerDataRepository;

  Future<void> call(Iterable<SimulationJumper> order) async {
    final managerData = await managerDataRepository.get();
    final canReorder =
        order.any((jumper) => managerData.personalCoachTeam!.jumpers.contains(jumper));
    if (!canReorder) {
      throw ArgumentError(
          'Cannot reorder trainees because passed order contains a jumper which hasn\'t belonged to the team');
    }
    managerData.personalCoachTeam!.jumpers = order.toList();
  }
}
