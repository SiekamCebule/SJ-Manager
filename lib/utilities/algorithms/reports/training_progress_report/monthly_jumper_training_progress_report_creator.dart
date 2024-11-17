import 'package:sj_manager/utilities/algorithms/reports/training_progress_report/training_report_creator.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/domain/entities/simulation/flow/simple_rating.dart';

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

  static const Map<TrainingProgressCategory, Map<SimpleRating, double>> requirements = {
    TrainingProgressCategory.takeoff: {
      SimpleRating.excellent: 0.4,
      SimpleRating.veryGood: 0.266,
      SimpleRating.good: 0.133,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.133,
      SimpleRating.poor: -0.266,
      SimpleRating.veryPoor: -0.4,
    },
    TrainingProgressCategory.flight: {
      SimpleRating.excellent: 0.4,
      SimpleRating.veryGood: 0.266,
      SimpleRating.good: 0.133,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.133,
      SimpleRating.poor: -0.266,
      SimpleRating.veryPoor: -0.4,
    },
    TrainingProgressCategory.landing: {
      SimpleRating.excellent: 0.2,
      SimpleRating.veryGood: 0.133,
      SimpleRating.good: 0.066,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.066,
      SimpleRating.poor: -0.133,
      SimpleRating.veryPoor: -0.2,
    },
    TrainingProgressCategory.consistency: {
      SimpleRating.excellent: 5,
      SimpleRating.veryGood: 3,
      SimpleRating.good: 1.25,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -1.25,
      SimpleRating.poor: -3,
      SimpleRating.veryPoor: -5,
    },
    TrainingProgressCategory.form: {
      SimpleRating.excellent: 3,
      SimpleRating.veryGood: 2,
      SimpleRating.good: 1,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -1,
      SimpleRating.poor: -2,
      SimpleRating.veryPoor: -3,
    },
  };
}
