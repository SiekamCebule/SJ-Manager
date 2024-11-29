import 'package:sj_manager/core/career_mode/career_mode_utils/reports/training_progress_report/weekly_jumper_training_progress_report_creator.dart';
import 'package:sj_manager/core/general_utils/datetime.dart';
import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/repository/simulation_current_date_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/jumper_stats/domain/entities/jumper_attribute.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

class CreateMonthlyTrainingSingleReportUseCase {
  const CreateMonthlyTrainingSingleReportUseCase({
    required this.currentDateRepository,
  });

  final SimulationCurrentDateRepository currentDateRepository;

  Future<TrainingReport> call(SimulationJumper jumper) async {
    final currentDate = await currentDateRepository.get();
    final daysInCurrentMonth = daysInMonth(currentDate.year, currentDate.month);
    final attributeHistrory = jumper.stats.progressableAttributeHistory;
    List<double> getDeltas(JumperAttributeType category) {
      final deltas = attributeHistrory[category]!.toDeltasList();
      final lastDeltas =
          deltas.reversed.take(daysInCurrentMonth).toList().reversed.toList();
      return lastDeltas.map((number) => number.toDouble()).toList();
    }

    return WeeklyJumperTrainingProgressReportCreator(deltas: {
      TrainingProgressCategory.takeoff: getDeltas(JumperAttributeType.takeoffQuality),
      TrainingProgressCategory.flight: getDeltas(JumperAttributeType.flightQuality),
      TrainingProgressCategory.landing: getDeltas(JumperAttributeType.landingQuality),
      TrainingProgressCategory.consistency: getDeltas(JumperAttributeType.consistency),
      TrainingProgressCategory.form: getDeltas(JumperAttributeType.form),
    }).create()!;
  }
}
