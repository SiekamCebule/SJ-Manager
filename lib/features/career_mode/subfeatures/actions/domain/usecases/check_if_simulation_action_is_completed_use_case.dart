import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';

class CheckIfSimulationActionIsCompletedUseCase {
  CheckIfSimulationActionIsCompletedUseCase({
    required this.actionsRepository,
  });

  final SimulationActionsRepository actionsRepository;

  Future<bool> call(SimulationActionType actionType) async {
    return await actionsRepository.isCompleted(actionType);
  }
}
