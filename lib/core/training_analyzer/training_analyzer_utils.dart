import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_result.dart';

String formatTrainingDetail(String label, double skill) {
  return '$label(${skill.toStringAsFixed(2)}})';
}

String formatJumperTrainingResultResultForAnalyzer(JumperTrainingResult result) {
  final takeoff = formatTrainingDetail(
    'wyb',
    result.takeoffDelta,
  );

  final flight = formatTrainingDetail(
    'lot',
    result.flightDelta,
  );

  final landing = formatTrainingDetail(
    'ląd',
    result.landingDelta,
  );

  final form = 'form(${result.formDelta.toStringAsFixed(2)})';

  final consistency = 'cons(${result.consistencyDelta.toStringAsFixed(2)})';
  final fatigue = 'fat(${result.fatigueDelta.toStringAsFixed(2)})';

  return '$takeoff, $flight, $landing, $form, $consistency, $fatigue';
}
