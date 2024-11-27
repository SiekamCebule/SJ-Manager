import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';

class GetAllSimulationActionsUseCase {
  GetAllSimulationActionsUseCase({
    required this.actionsRepository,
  });

  final SimulationActionsRepository actionsRepository;

  Future<Iterable<SimulationAction>> call() async {
    return await actionsRepository.getAll();
  }
}
