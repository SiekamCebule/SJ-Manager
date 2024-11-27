import 'package:collection/collection.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';

class GetSortedIncompletedSimulationActionsUseCase {
  GetSortedIncompletedSimulationActionsUseCase({
    required this.actionsRepository,
  });

  final SimulationActionsRepository actionsRepository;

  /// Od najpóźniejszego. Nulle idą na sam koniec
  Future<Iterable<SimulationAction>> call() async {
    final actions = await actionsRepository.getAll();
    return actions
        .where((action) => !action.isCompleted)
        .sorted((a, b) => b.deadline?.compareTo(a.deadline ?? DateTime.now()) ?? -1);
  }
}
