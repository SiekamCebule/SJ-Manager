import 'package:sj_manager/features/career_mode/subfeatures/training/domain/training_engine/training_engine_entity.dart';
import 'package:sj_manager/core/training_analyzer/training_analyzer_result.dart';
import 'package:sj_manager/core/training_analyzer/training_segment.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/training_engine/jumper_training_engine.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/training_engine/jumper_training_engine_settings.dart';

class TrainingTestRunner {
  const TrainingTestRunner({
    required this.segments,
    required this.entity,
    required this.engineSettings,
    required this.daysToSimulate,
  });

  final List<TrainingSegment> segments;
  final TrainingEngineEntity entity;
  final JumperTrainingEngineSettings engineSettings;
  final int daysToSimulate;

  TrainingAnalyzerResult run() {
    final dayResults = <TrainingAnalyzerDaySimulationResult>[];
    var currentEntity = entity;
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
        entity: entity,
      );
      final trainingResult = engine.doTraining();
      lastResult = TrainingAnalyzerDaySimulationResult(
        day: day,
        trainingResult: trainingResult,
      );
      currentEntity = currentEntity.copyWith(
        form: trainingResult.formDelta,
        jumpsConsistency: trainingResult.consistencyDelta,
        fatigue: trainingResult.fatigueDelta,
        takeoffQuality: trainingResult.takeoffDelta,
        flightQuality: trainingResult.flightDelta,
        landingQuality: trainingResult.landingDelta,
      );
      dayResults.add(lastResult);
    }
    return TrainingAnalyzerResult(
      segments: segments,
      dayResults: dayResults,
    );
  }
}
