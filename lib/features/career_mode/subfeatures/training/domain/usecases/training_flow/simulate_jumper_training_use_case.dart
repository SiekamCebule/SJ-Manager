import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/repository/simulation_current_date_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumper_stats/domain/repository/jumper_stats_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/data/mappers/jumper_to_training_engine_entity.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/training_engine/jumper_training_engine.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumper_stats/domain/usecases/register_jumper_attributes_use_case.dart';

class SimulateJumperTrainingUseCase {
  SimulateJumperTrainingUseCase({
    required this.statsRepository,
    required this.currentDateRepository,
    required this.registerTraining,
  });

  final JumperStatsRepository statsRepository;
  final SimulationCurrentDateRepository currentDateRepository;
  final RegisterJumperAttributesUseCase registerTraining;

  Future<void> call(SimulationJumper jumper) async {
    if (jumper.trainingConfig == null) {
      throw StateError(
        'Cannot simulate the training for particular jumper ($jumper) because it did not get the training configurated',
      );
    }

    final trainingResult = JumperTrainingEngine(
      entity: jumper.toTrainingEngineEntity(),
    ).doTraining();

    jumper.takeoffQuality += trainingResult.takeoffDelta;
    jumper.flightQuality += trainingResult.flightDelta;
    jumper.landingQuality += trainingResult.landingDelta;
    jumper.form += trainingResult.formDelta;
    jumper.jumpsConsistency += trainingResult.consistencyDelta;
    jumper.fatigue += trainingResult.fatigueDelta;

    await registerTraining(jumper: jumper, result: trainingResult);
  }
}
