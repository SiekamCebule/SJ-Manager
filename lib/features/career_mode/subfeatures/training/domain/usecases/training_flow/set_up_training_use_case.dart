import 'package:sj_manager/core/career_mode/career_mode_utils/start_form/default_start_form_algorithm.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';

class SetUpTrainingUseCase {
  SetUpTrainingUseCase({
    required this.actionsRepository,
    required this.jumpersRepository,
  });

  final SimulationActionsRepository actionsRepository;
  final SimulationJumpersRepository jumpersRepository;

  Future<void> execute() async {
    final jumpers = await jumpersRepository.getAll();
    for (var jumper in jumpers) {
      jumper.trainingConfig = initialJumperTrainingConfig;
      jumper.form = DefaultStartFormAlgorithm(baseForm: jumper.form).computeStartForm();
    }
    await actionsRepository.complete(SimulationActionType.settingUpTraining);
  }
}
