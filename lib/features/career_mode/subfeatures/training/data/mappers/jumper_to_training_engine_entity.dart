import 'package:sj_manager/features/career_mode/subfeatures/training/domain/training_engine/training_engine_entity.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

extension ToTrainingEngineEntity on SimulationJumper {
  TrainingEngineEntity toTrainingEngineEntity() {
    return TrainingEngineEntity(
      takeoffQuality: takeoffQuality,
      flightQuality: flightQuality,
      landingQuality: landingQuality,
      form: form,
      jumpsConsistency: jumpsConsistency,
      morale: morale,
      fatigue: fatigue,
      levelOfConsciousness: levelOfConsciousness,
      trainingConfig: trainingConfig,
    );
  }
}
