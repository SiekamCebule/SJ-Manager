import 'package:sj_manager/core/career_mode/career_mode_utils/reports/default_jumper_level_report_creator.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/simulation_database_use_cases.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/reports/jumper_level_description.dart';

class SetUpJumperLevelReportsUseCase {
  SetUpJumperLevelReportsUseCase({
    required this.database,
    required this.levelRequirements,
  });

  final SimulationDatabase database;
  final Map<JumperLevelDescription, double> levelRequirements;

  void execute() {
    for (var jumper in database.jumpers) {
      final report = DefaultJumperLevelReportCreator(requirements: levelRequirements)
          .create(jumper: jumper);
      SimulationDatabaseUseCases(database: database)
          .setLevelReport(jumper: jumper, report: report);
    }
  }
}
