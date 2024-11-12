import 'package:flutter/material.dart';
import 'package:sj_manager/algorithms/reports/default_jumper_level_report_creator.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_level_description.dart';

class SetUpJumperLevelReportsCommand {
  SetUpJumperLevelReportsCommand({
    required this.context,
    required this.database,
    required this.levelRequirements,
    required this.onFinish,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Map<JumperLevelDescription, double> levelRequirements;
  final void Function(SimulationDatabase changedDatabase) onFinish;

  void execute() {
    final changedJumpersReports = Map.of(database.jumperReports);
    for (var jumper in database.jumpers) {
      final report = DefaultJumperLevelReportCreator(requirements: levelRequirements)
          .create(jumper: jumper);
      changedJumpersReports[jumper] =
          changedJumpersReports[jumper]!.copyWith(levelReport: report);
    }

    final changedDatabase = database.copyWith(jumperReports: changedJumpersReports);
    onFinish(changedDatabase);
  }
}
