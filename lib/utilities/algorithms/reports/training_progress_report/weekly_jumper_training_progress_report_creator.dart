import 'package:sj_manager/utilities/algorithms/reports/training_progress_report/training_report_creator.dart';
import 'package:sj_manager/data/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/data/models/simulation/flow/simple_rating.dart';

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

  static const Map<TrainingProgressCategory, Map<SimpleRating, double>> requirements = {
    TrainingProgressCategory.takeoff: {
      SimpleRating.excellent: 0.25,
      SimpleRating.veryGood: 0.125,
      SimpleRating.good: 0.075,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.075,
      SimpleRating.poor: -0.125,
      SimpleRating.veryPoor: -0.25,
    },
    TrainingProgressCategory.flight: {
      SimpleRating.excellent: 0.25,
      SimpleRating.veryGood: 0.125,
      SimpleRating.good: 0.075,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.075,
      SimpleRating.poor: -0.125,
      SimpleRating.veryPoor: -0.25,
    },
    TrainingProgressCategory.landing: {
      SimpleRating.excellent: 0.1,
      SimpleRating.veryGood: 0.066,
      SimpleRating.good: 0.033,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.033,
      SimpleRating.poor: -0.066,
      SimpleRating.veryPoor: -0.1,
    },
    TrainingProgressCategory.consistency: {
      SimpleRating.excellent: 1.8,
      SimpleRating.veryGood: 1,
      SimpleRating.good: 0.4,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.4,
      SimpleRating.poor: -1,
      SimpleRating.veryPoor: -1.8,
    },
    TrainingProgressCategory.form: {
      SimpleRating.excellent: 1.6,
      SimpleRating.veryGood: 1.06,
      SimpleRating.good: 0.53,
      SimpleRating.correct: 0.0,
      SimpleRating.belowExpectations: -0.53,
      SimpleRating.poor: -1.06,
      SimpleRating.veryPoor: -1.6,
    },
  };
}
