import 'package:sj_manager/core/career_mode/career_mode_utils/training/training_engine/jumper_training_result.dart';

String formatTrainingDetail(String label, double skill) {
  return '$label(${skill.toStringAsFixed(2)}})';
}

String formatJumperTrainingResultResultForAnalyzer(JumperTrainingResult result) {
  final takeoff = formatTrainingDetail(
    'wyb',
    result.takeoffQuality,
  );

  final flight = formatTrainingDetail(
    'lot',
    result.flightQuality,
  );

  final landing = formatTrainingDetail(
    'ląd',
    result.landingQuality,
  );

  final form = 'form(${result.form.toStringAsFixed(2)})';

  final consistency = 'cons(${result.jumpsConsistency.toStringAsFixed(2)})';
  final fatigue = 'fat(${result.fatigue.toStringAsFixed(2)})';

  return '$takeoff, $flight, $landing, $form, $consistency, $fatigue';
}
