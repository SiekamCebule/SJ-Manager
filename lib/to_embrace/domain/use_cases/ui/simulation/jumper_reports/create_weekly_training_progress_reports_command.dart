import 'package:sj_manager/core/career_mode/career_mode_utils/reports/training_progress_report/weekly_jumper_training_progress_report_creator.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class CreateWeeklyTrainingProgressReportsCommand {
  const CreateWeeklyTrainingProgressReportsCommand({
    required this.database,
  });
  final SimulationDatabase database;

  void execute() {
    final reports = <SimulationJumper, TrainingReport?>{};
    for (var jumper in database.jumpers) {
      final attributeHistrory = jumper.stats.progressableAttributeHistory;
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
      SimulationDatabaseUseCases(database: database)
          .setWeeklyReport(jumper: jumper, report: report);
    });
  }
}
