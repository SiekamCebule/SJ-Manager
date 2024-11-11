import 'package:sj_manager/algorithms/reports/training_progress_report/training_report_creator.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

class WeeklyJumperTrainingProgressReportCreator {
  WeeklyJumperTrainingProgressReportCreator({
    required this.deltas,
  });

  final Map<TrainingProgressCategory, List<double>> deltas;

  TrainingReport? create() {
    return TrainingReportCreator(
      deltas: deltas,
      requirements: requirements,
    ).create();
  }

  static const requirements = {
    TrainingProgressCategory.takeoff: {
      SimpleRating.excellent: 0.5,
      SimpleRating.veryGood: 0.3,
      SimpleRating.good: 0.1,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.1,
      SimpleRating.poor: -0.3,
      SimpleRating.veryPoor: -0.5,
    },
    TrainingProgressCategory.flight: {
      SimpleRating.excellent: 0.5,
      SimpleRating.veryGood: 0.3,
      SimpleRating.good: 0.1,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.1,
      SimpleRating.poor: -0.3,
      SimpleRating.veryPoor: -0.5,
    },
    TrainingProgressCategory.landing: {
      SimpleRating.excellent: 0.15,
      SimpleRating.veryGood: 0.1,
      SimpleRating.good: 0.05,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.05,
      SimpleRating.poor: -0.1,
      SimpleRating.veryPoor: -0.15,
    },
    TrainingProgressCategory.consistency: {
      SimpleRating.excellent: 0.6,
      SimpleRating.veryGood: 0.4,
      SimpleRating.good: 0.2,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.2,
      SimpleRating.poor: -0.4,
      SimpleRating.veryPoor: -0.6,
    },
    TrainingProgressCategory.form: {
      SimpleRating.excellent: 1.2,
      SimpleRating.veryGood: 0.8,
      SimpleRating.good: 0.4,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.4,
      SimpleRating.poor: -0.8,
      SimpleRating.veryPoor: -1.2,
    },
  };
}
