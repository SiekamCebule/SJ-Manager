import 'package:sj_manager/utilities/algorithms/reports/training_progress_report/monthly_jumper_training_progress_report_creator.dart';
import 'package:sj_manager/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/domain/entities/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/domain/entities/simulation/jumper/simulation_jumper.dart';
import 'package:sj_manager/utilities/utils/datetime.dart';

class CreateMonthlyTrainingProgressReportsCommand {
  const CreateMonthlyTrainingProgressReportsCommand({
    required this.database,
    required this.endedMonth,
    required this.yearDuringEndedMonth,
  });
  final SimulationDatabase database;
  final int endedMonth;
  final int yearDuringEndedMonth;

  void execute() {
    final reports = <SimulationJumper, TrainingReport?>{};
    for (var jumper in database.jumpers) {
      final attributeHistrory = jumper.stats.progressableAttributeHistory;
      List<double> getDeltas(TrainingProgressCategory category) {
        final deltas = attributeHistrory[category]!.toDeltasList();
        final lastDeltas = deltas.reversed
            .take(daysInMonth(yearDuringEndedMonth, endedMonth))
            .toList()
            .reversed
            .toList();
        return lastDeltas.map((number) => number.toDouble()).toList();
      }

      final report = MonthlyJumperTrainingProgressReportCreator(deltas: {
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
          .setMonthlyReport(jumper: jumper, report: report);
    });
  }
}
