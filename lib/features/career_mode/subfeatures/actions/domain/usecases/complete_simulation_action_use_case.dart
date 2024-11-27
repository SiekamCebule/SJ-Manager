import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';

class CompleteSimulationActionUseCase {
  CompleteSimulationActionUseCase({
    required this.actionsRepository,
  });

  final SimulationActionsRepository actionsRepository;

  Future<void> call(SimulationActionType actionType) async {
    await actionsRepository.complete(actionType);
  }
}
