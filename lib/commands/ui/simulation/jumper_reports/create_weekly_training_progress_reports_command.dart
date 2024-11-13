import 'package:sj_manager/algorithms/reports/training_progress_report/weekly_jumper_training_progress_report_creator.dart';
import 'package:sj_manager/commands/simulation_database/simulation_database_commander.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';

class CreateWeeklyTrainingProgressReportsCommand {
  const CreateWeeklyTrainingProgressReportsCommand({
    required this.database,
  });
  final SimulationDatabase database;

  void execute() {
    final dbHelper = SimulationDatabaseHelper(database: database);
    final reports = <SimulationJumper, TrainingReport?>{};
    for (var jumper in database.jumpers) {
      final attributeHistrory =
          dbHelper.jumperStats(jumper)!.progressableAttributeHistory;
      List<double> getDeltas(TrainingProgressCategory category) {
        final deltas = attributeHistrory[category]!.toDeltasList();
        final lastDeltas = deltas.reversed.take(7).toList().reversed.toList();
        return lastDeltas.map((number) => number.toDouble()).toList();
      }

      final report = WeeklyJumperTrainingProgressReportCreator(deltas: {
        TrainingProgressCategory.takeoff: getDeltas(TrainingProgressCategory.takeoff),
        TrainingProgressCategory.flight: getDeltas(TrainingProgressCategory.flight),
        TrainingProgressCategory.landing: getDeltas(TrainingProgressCategory.landing),
        TrainingProgressCategory.consistency:
            getDeltas(TrainingProgressCategory.consistency),
        TrainingProgressCategory.form: getDeltas(TrainingProgressCategory.form),
      }).create();

      reports[jumper] = report;
    }
    reports.forEach((jumper, report) {
      SimulationDatabaseCommander(database: database)
          .setWeeklyReport(jumper: jumper, report: report);
    });
  }
}
