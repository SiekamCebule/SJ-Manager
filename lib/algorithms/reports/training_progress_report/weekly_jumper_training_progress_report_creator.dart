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
      SimpleRating.correct: -0.1,
      SimpleRating.belowExpectations: -0.3,
      SimpleRating.poor: -0.5,
      SimpleRating.veryPoor: -0.7,
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
      SimpleRating.excellent: 0.3,
      SimpleRating.veryGood: 0.15,
      SimpleRating.good: 0.05,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.05,
      SimpleRating.poor: -0.15,
      SimpleRating.veryPoor: -0.3,
    },
    TrainingProgressCategory.consistency: {
      SimpleRating.excellent: 0.8,
      SimpleRating.veryGood: 0.5,
      SimpleRating.good: 0.3,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.3,
      SimpleRating.poor: -0.5,
      SimpleRating.veryPoor: -0.8,
    },
    TrainingProgressCategory.form: {
      SimpleRating.excellent: 0.5,
      SimpleRating.veryGood: 0.3,
      SimpleRating.good: 0.15,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.15,
      SimpleRating.poor: -0.3,
      SimpleRating.veryPoor: -0.5,
    },
  };
}
