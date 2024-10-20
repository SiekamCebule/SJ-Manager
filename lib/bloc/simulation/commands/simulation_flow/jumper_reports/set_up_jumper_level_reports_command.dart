import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/commands/simulation_flow/jumper_reports/default_jumper_level_report_creator.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_level_description.dart';

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
    final changedJumpersReports = Map.of(database.jumpersReports);
    for (var jumper in database.jumpers.last) {
      final report = DefaultJumperLevelReportCreator(requirements: levelRequirements)
          .create(jumper: jumper);
      changedJumpersReports[jumper] =
          changedJumpersReports[jumper]!.copyWith(levelReport: report);
    }

    final changedDatabase = database.copyWith(jumpersReports: changedJumpersReports);
    context.read<SimulationDatabaseCubit>().update(changedDatabase);
  }
}
