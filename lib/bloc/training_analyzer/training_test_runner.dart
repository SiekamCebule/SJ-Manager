import 'package:sj_manager/models/training_analyzer/training_analyzer_result.dart';
import 'package:sj_manager/models/training_analyzer/training_segment.dart';
import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/training_engine/jumper_training_engine.dart';
import 'package:sj_manager/training_engine/jumper_training_engine_settings.dart';

class TrainingTestRunner {
  const TrainingTestRunner({
    required this.segments,
    required this.dynamicParams,
    required this.jumperSkills,
    required this.engineSettings,
    required this.daysToSimulate,
  });

  final List<TrainingSegment> segments;
  final JumperDynamicParams dynamicParams;
  final JumperSkills jumperSkills;
  final JumperTrainingEngineSettings engineSettings;
  final int daysToSimulate;

  TrainingAnalyzerResult run() {
    final dayResults = <TrainingAnalyzerDaySimulationResult>[];
    var currentDynamicParams = dynamicParams;
    var currentJumperSkills = jumperSkills;
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
        jumperSkills: currentJumperSkills,
        dynamicParams: currentDynamicParams.copyWith(
          trainingConfig: applicableSegment.trainingConfig,
        ),
        scaleFactor: applicableSegment.scale,
      );
      final trainingResult = engine.doTraining();
      lastResult = TrainingAnalyzerDaySimulationResult(
        day: day,
        trainingResult: trainingResult,
      );
      currentDynamicParams = currentDynamicParams.copyWith(
        form: trainingResult.form,
        trainingFeeling: trainingResult.trainingFeeling,
        jumpsConsistency: trainingResult.jumpsConsistency,
        fatigue: trainingResult.fatigue,
      );
      currentJumperSkills = trainingResult.skills;
      dayResults.add(lastResult);
    }
    return TrainingAnalyzerResult(
      segments: segments,
      dayResults: dayResults,
    );
  }
}
