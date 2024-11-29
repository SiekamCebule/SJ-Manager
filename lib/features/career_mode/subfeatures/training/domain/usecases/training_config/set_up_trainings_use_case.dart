import 'package:sj_manager/core/career_mode/career_mode_utils/start_form/default_start_form_algorithm.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumpers/domain/repository/simulation_jumpers_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';

class SetUpTrainingsUseCase {
  SetUpTrainingsUseCase({
    required this.actionsRepository,
    required this.jumpersRepository,
  });

  final SimulationActionsRepository actionsRepository;
  final SimulationJumpersRepository jumpersRepository;

  Future<void> call() async {
    for (final jumper in await jumpersRepository.getAll()) {
      jumper.trainingConfig = initialJumperTrainingConfig;
      jumper.form = DefaultStartFormAlgorithm(baseForm: jumper.form).computeStartForm();
      print('jumper\'s form: ${jumper.form}');
    }
    await actionsRepository.complete(SimulationActionType.settingUpTraining);
  }
}
