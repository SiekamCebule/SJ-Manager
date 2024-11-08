import 'package:sj_manager/algorithms/reports/training_progress_report/training_report_creator.dart';
import 'package:sj_manager/algorithms/reports/training_progress_report/weekly_jumper_training_progress_report_creator.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';

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

  static final requirements = WeeklyJumperTrainingProgressReportCreator.requirements
      .map((category, requirements) {
    return MapEntry(category, requirements.map((rating, requirement) {
      return MapEntry(rating, requirement * weekToMonthMultiplier);
    }));
  });
}
