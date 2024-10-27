import 'package:sj_manager/models/simulation/flow/training/jumping_technique_change_training.dart';
import 'package:sj_manager/models/user_db/psyche/level_of_consciousness_labels.dart';

class JumpingTechniqueChangeTrainingDurationCalculator {
  static const multipliersByConsciousness = {
    LevelOfConsciousnessLabels.shame: 25.0,
    LevelOfConsciousnessLabels.guilt: 22.0,
    LevelOfConsciousnessLabels.apathy: 17.0,
    LevelOfConsciousnessLabels.grief: 12.0,
    LevelOfConsciousnessLabels.fear: 10.0,
    LevelOfConsciousnessLabels.desire: 6.0,
    LevelOfConsciousnessLabels.anger: 5.0,
    LevelOfConsciousnessLabels.pride: 4.0,
    LevelOfConsciousnessLabels.courage: 3.0,
    LevelOfConsciousnessLabels.neutrality: 2.0,
    LevelOfConsciousnessLabels.willingness: 1.55,
    LevelOfConsciousnessLabels.acceptance: 1.2,
    LevelOfConsciousnessLabels.reason: 1,
    LevelOfConsciousnessLabels.love: 0.6,
    LevelOfConsciousnessLabels.joy: 0.3,
    LevelOfConsciousnessLabels.peace: 0.1,
    LevelOfConsciousnessLabels.enlightenment: 0.025,
  };

  int calculateDays({
    required JumpingTechniqueChangeTrainingType trainingType,
    required LevelOfConsciousness levelOfConsciousness,
  }) {
    if (trainingType == JumpingTechniqueChangeTrainingType.maintain) {
      throw ArgumentError(
        'Cannot calculate days for JumpingTechniqueChangeTrainingType.maintain',
      );
    }
    int baseDays;
    if (trainingType == JumpingTechniqueChangeTrainingType.increaseRisk) {
      baseDays = 30;
    } else {
      baseDays = 12;
    }
    final days = baseDays * multipliersByConsciousness[levelOfConsciousness.label]!;
    return days.round();
  }
}
