import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/training_analyzer/training_segment.dart';
import 'package:sj_manager/training_engine/jumper_training_result.dart';

class TrainingAnalyzerResult with EquatableMixin {
  const TrainingAnalyzerResult({
    required this.segments,
    required this.dayResults,
  });

  final List<TrainingSegment> segments;
  final List<TrainingAnalyzerDaySimulationResult> dayResults;

  @override
  List<Object?> get props => [
        segments,
        dayResults,
      ];
}

class TrainingAnalyzerDaySimulationResult with EquatableMixin {
  const TrainingAnalyzerDaySimulationResult({
    required this.day,
    required this.trainingResult,
  });

  final int day;
  final JumperTrainingResult trainingResult;

  @override
  List<Object?> get props => [
        day,
        trainingResult,
      ];

  String toCsv({
    required String delimiter,
  }) {
    return [
      day.toString(),
      trainingResult.skills.takeoffQuality.toStringAsFixed(2),
      trainingResult.trainingFeeling[JumperTrainingCategory.takeoff]?.toStringAsFixed(2),
      trainingResult.skills.flightQuality.toStringAsFixed(2),
      trainingResult.trainingFeeling[JumperTrainingCategory.flight]?.toStringAsFixed(2),
      trainingResult.skills.landingQuality.toStringAsFixed(2),
      trainingResult.trainingFeeling[JumperTrainingCategory.landing]?.toStringAsFixed(2),
      trainingResult.form.toStringAsFixed(2),
      trainingResult.jumpsConsistency.toStringAsFixed(2),
      trainingResult.fatigue.toStringAsFixed(2)
    ].join(delimiter);
  }

  static String listToCsv(
    List<TrainingAnalyzerDaySimulationResult> results, {
    required String delimiter,
  }) {
    final buffer = StringBuffer();

    buffer.writeln([
      'Day',
      'TakeoffQuality',
      'TakeoffFactor',
      'TakeoffFeeling',
      'FlightQuality',
      'FlightFactor',
      'FlightFeeling',
      'LandingQuality',
      'LandingFactor',
      'LandingFeeling',
      'Form',
      'Consistency',
      'Fatigue'
    ].join(delimiter));

    for (var day = 1; day <= results.length; day++) {
      final result = results[day - 1];
      final resultInCsv = result.toCsv(delimiter: delimiter).replaceAll('.', ',');
      final csvLine = '$day$delimiter$resultInCsv';
      buffer.writeln(csvLine);
    }

    return buffer.toString();
  }
}
