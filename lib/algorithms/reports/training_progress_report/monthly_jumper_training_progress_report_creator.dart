import 'package:sj_manager/algorithms/reports/training_progress_report/training_report_creator.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

class MonthlyJumperTrainingProgressReportCreator {
  MonthlyJumperTrainingProgressReportCreator({
    required this.deltas,
  });

  final Map<TrainingProgressCategory, List<double>> deltas;

  TrainingReport? create() {
    return TrainingReportCreator(
      deltas: deltas,
      requirements: requirements,
    ).create();
  }

  static const double weekToMonthMultiplier = 2;

  static const requirements = {
    TrainingProgressCategory.takeoff: {
      SimpleRating.excellent: 1,
      SimpleRating.veryGood: 0.66,
      SimpleRating.good: 0.33,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.33,
      SimpleRating.poor: -0.66,
      SimpleRating.veryPoor: -1,
    },
    TrainingProgressCategory.flight: {
      SimpleRating.excellent: 1,
      SimpleRating.veryGood: 0.66,
      SimpleRating.good: 0.33,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.33,
      SimpleRating.poor: -0.66,
      SimpleRating.veryPoor: -1,
    },
    TrainingProgressCategory.landing: {
      SimpleRating.excellent: 0.25,
      SimpleRating.veryGood: 0.15,
      SimpleRating.good: 0.075,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.075,
      SimpleRating.poor: -0.15,
      SimpleRating.veryPoor: -0.25,
    },
    TrainingProgressCategory.consistency: {
      SimpleRating.excellent: 2,
      SimpleRating.veryGood: 1.33,
      SimpleRating.good: 0.66,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.66,
      SimpleRating.poor: -1.33,
      SimpleRating.veryPoor: -2,
    },
    TrainingProgressCategory.form: {
      SimpleRating.excellent: 2.5,
      SimpleRating.veryGood: 1.666,
      SimpleRating.good: 0.833,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.833,
      SimpleRating.poor: -1.666,
      SimpleRating.veryPoor: -2.5,
    },
  };
}
