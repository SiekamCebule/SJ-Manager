import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_reports.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';

abstract interface class JumperReportsRepository {
  Future<TrainingReport?> getMontlyTrainingReport(SimulationJumper jumper);
  Future<TrainingReport?> getWeeklyTrainingReport(SimulationJumper jumper);
  Future<JumperLevelReport> getLevelReport(SimulationJumper jumper);

  Future<void> setMonthlyTrainingReport({
    required SimulationJumper jumper,
    required TrainingReport report,
  });

  Future<void> setWeeklyTrainingReport({
    required SimulationJumper jumper,
    required TrainingReport report,
  });

  Future<void> setLevelReport({
    required SimulationJumper jumper,
    required JumperLevelReport report,
  });
}
