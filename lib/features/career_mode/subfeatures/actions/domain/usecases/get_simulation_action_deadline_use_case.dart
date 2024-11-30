import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';

class GetSimulationActionDeadlineUseCase {
  GetSimulationActionDeadlineUseCase({
    required this.actionsRepository,
  });

  final SimulationActionsRepository actionsRepository;

  Future<DateTime?> call(SimulationActionType actionType) async {
    final actions = await actionsRepository.getAll();
    return actions.singleWhere((action) => action.type == actionType).deadline;
  }
}
