import 'package:sj_manager/bloc/simulation/commands/simulation_flow/training/simulate_jumper_training_command.dart';
import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/jumper/jumping_technique.dart';
import 'package:sj_manager/models/user_db/psyche/level_of_consciousness_labels.dart';
import 'package:sj_manager/models/user_db/psyche/personalities.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

void main(List<String> args) {
  final jumper = MaleJumper(
    name: 'Jakub',
    surname: 'Wolny',
    country: const Country(
        code: 'pl', multilingualName: MultilingualString(valuesByLanguage: {})),
    dateOfBirth: DateTime.now(),
    personality: Personalities.stubborn,
    skills: const JumperSkills(
        takeoffQuality: 12.75,
        flightQuality: 14.9,
        landingQuality: 16,
        jumpingTechnique: JumpingTechnique.fairlyUnpredictable),
  );
  final dynamicParams = JumperDynamicParams(
    trainingConfig: const JumperTrainingConfig(points: {
      JumperTrainingPointsCategory.takeoff: 6,
      JumperTrainingPointsCategory.flight: 13,
      JumperTrainingPointsCategory.landing: 4,
      JumperTrainingPointsCategory.jumpsConsistency: 10,
      JumperTrainingPointsCategory.form: 10,
    }), // max: 40
    form: 10,
    trainingEffeciencyFactor: 0.6, // 60%
    jumpsConsistency: 14,
    morale: 0.2,
    fatigue: 0.14,
    levelOfConsciousness:
        LevelOfConsciousness.fromMapOfConsciousness(LevelOfConsciousnessLabels.anger),
  );
  final simulator = JumperTrainingSimulator(
    jumper: jumper,
    dynamicParams: dynamicParams,
    scale: 1.0, // 1 dzień treningowy
  );
  final trainingResult = simulator.simulateTraining();
  print('training result: $trainingResult');
}
