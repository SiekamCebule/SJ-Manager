import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';

class GetSimulationActionsCompletionMapUseCase {
  GetSimulationActionsCompletionMapUseCase({
    required this.actionsRepository,
  });

  final SimulationActionsRepository actionsRepository;

  Future<Map<SimulationActionType, bool>> call() async {
    return await actionsRepository.getCompletionMap();
  }
}
