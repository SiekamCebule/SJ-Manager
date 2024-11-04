import 'package:sj_manager/algorithms/reports/training_progress_report/monthly_jumper_training_progress_report_creator.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class CreateMonthlyTrainingProgressReportsCommand {
  const CreateMonthlyTrainingProgressReportsCommand({
    required this.database,
  });
  final SimulationDatabase database;

  Future<SimulationDatabase> execute() async {
    var database = this.database;
    final reports = <Jumper, TrainingReport>{};
    for (var jumper in database.jumpers.last) {
      final deltas = [-0.4, 0.3, -0.03, -0.1, -0.2, 0.05, 0.0]; // TODO
      final report = MonthlyJumperTrainingProgressReportCreator(deltas: {
        JumperTrainingProgressCategory.takeoff: deltas,
        JumperTrainingProgressCategory.flight: deltas,
        JumperTrainingProgressCategory.landing: deltas,
        JumperTrainingProgressCategory.consistency: deltas,
        JumperTrainingProgressCategory.form: deltas,
      }).create();
      reports[jumper] = report;
    }
    final changedJumperReports = Map.of(database.jumperReports);
    reports.forEach((jumper, report) {
      changedJumperReports[jumper] =
          changedJumperReports[jumper]!.copyWith(monthlyTrainingReport: report);
    });
    return database;
  }
}
