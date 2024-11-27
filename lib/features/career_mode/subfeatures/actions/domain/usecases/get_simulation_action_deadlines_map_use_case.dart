import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';

class GetSimulationActionDeadlinesMapUseCase {
  GetSimulationActionDeadlinesMapUseCase({
    required this.actionsRepository,
  });

  final SimulationActionsRepository actionsRepository;

  Future<Map<SimulationActionType, DateTime?>> call() async {
    final actions = await actionsRepository.getAll();
    return {
      for (var action in actions) action.type: action.deadline,
    };
  }
}
