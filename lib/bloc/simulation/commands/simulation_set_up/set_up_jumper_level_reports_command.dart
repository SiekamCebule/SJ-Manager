import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_level_description.dart';
import 'package:sj_manager/models/simulation/flow/reports/jumper_reports.dart';
import 'package:sj_manager/models/simulation/flow/simple_rating.dart';

class SetUpJumperLevelReportsCommand {
  SetUpJumperLevelReportsCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  void execute() {
    final changedJumpersReports = Map.of(database.jumpersReports);
    for (var jumper in database.jumpers.last) {
      // TODO: Evaluate jumper\'s level
      const report = JumperLevelReport(
        levelDescription: JumperLevelDescription.broadTop,
        characteristics: {
          JumperLevelCharacteristicCategory.flight: SimpleRating.belowExpectations,
        },
      );
      changedJumpersReports[jumper] =
          changedJumpersReports[jumper]!.copyWith(levelReport: report);
    }

    final changedDatabase = database.copyWith(jumpersReports: changedJumpersReports);
    context.read<SimulationDatabaseCubit>().update(changedDatabase);
  }
}
