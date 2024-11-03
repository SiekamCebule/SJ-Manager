import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/training_engine/jumper_training_result.dart';

String formatTrainingDetail(String label, double skill, double? feeling) {
  return '$label(${skill.toStringAsFixed(2)}, ${feeling?.toStringAsFixed(2)})';
}

String formatJumperTrainingResultResultForAnalyzer(JumperTrainingResult result) {
  final takeoff = formatTrainingDetail('wyb', result.skills.takeoffQuality,
      result.trainingFeeling[JumperTrainingCategory.takeoff]);

  final flight = formatTrainingDetail('lot', result.skills.flightQuality,
      result.trainingFeeling[JumperTrainingCategory.flight]);

  final landing = formatTrainingDetail('ląd', result.skills.landingQuality,
      result.trainingFeeling[JumperTrainingCategory.landing]);

  final form = 'form(${result.form.toStringAsFixed(2)})';

  final consistency = 'cons(${result.jumpsConsistency.toStringAsFixed(2)})';
  final fatigue = 'fat(${result.fatigue.toStringAsFixed(2)})';

  return '$takeoff, $flight, $landing, $form, $consistency, $fatigue';
}
