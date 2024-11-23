import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/training_analyzer/training_analyzer_result.dart';
import 'package:sj_manager/core/training_analyzer/training_segment.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/training/training_engine/jumper_training_engine.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/training/training_engine/jumper_training_engine_settings.dart';

class TrainingTestRunner {
  const TrainingTestRunner({
    required this.segments,
    required this.jumper,
    required this.engineSettings,
    required this.daysToSimulate,
  });

  final List<TrainingSegment> segments;
  final SimulationJumper jumper;
  final JumperTrainingEngineSettings engineSettings;
  final int daysToSimulate;

  TrainingAnalyzerResult run() {
    final dayResults = <TrainingAnalyzerDaySimulationResult>[];
    var currentJumper = jumper;
    TrainingAnalyzerDaySimulationResult? lastResult;

    for (var day = 1; day < daysToSimulate + 1; day++) {
      final applicableSegment = segments.cast<TrainingSegment?>().firstWhere(
            (segment) => segment!.start <= day && segment.end >= day,
            orElse: () => null,
          );
      if (applicableSegment == null) {
        if (lastResult != null) {
          dayResults.add(lastResult);
          continue;
        } else {
          throw StateError('There is no training segment in passed list. Hmm...');
        }
      }
      final engine = JumperTrainingEngine(
        settings: engineSettings,
        jumper: jumper,
      );
      final trainingResult = engine.doTraining();
      lastResult = TrainingAnalyzerDaySimulationResult(
        day: day,
        trainingResult: trainingResult,
      );
      currentJumper = currentJumper.copyWith(
        form: trainingResult.form,
        jumpsConsistency: trainingResult.jumpsConsistency,
        fatigue: trainingResult.fatigue,
        takeoffQuality: trainingResult.takeoffQuality,
        flightQuality: trainingResult.flightQuality,
        landingQuality: trainingResult.landingQuality,
      );
      dayResults.add(lastResult);
    }
    return TrainingAnalyzerResult(
      segments: segments,
      dayResults: dayResults,
    );
  }
}
