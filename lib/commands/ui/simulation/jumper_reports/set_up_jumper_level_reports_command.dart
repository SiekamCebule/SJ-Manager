import 'package:flutter/material.dart';
import 'package:sj_manager/algorithms/reports/default_jumper_level_report_creator.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/jumper/reports/jumper_level_description.dart';

class SetUpJumperLevelReportsCommand {
  SetUpJumperLevelReportsCommand({
    required this.context,
    required this.database,
    required this.levelRequirements,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Map<JumperLevelDescription, double> levelRequirements;

  void execute() {
    final dbHelper = SimulationDatabaseHelper(database: database);
    for (var jumper in database.jumpers) {
      final report = DefaultJumperLevelReportCreator(requirements: levelRequirements)
          .create(jumper: jumper);
      database.jumperReports[dbHelper.id(jumper)]!.levelReport = report;
    }
  }
}
