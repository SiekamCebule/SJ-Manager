import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/set_up_subteams_command.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/set_up_trainings_command.dart';
import 'package:sj_manager/commands/simulation/common/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/utils/datetime.dart';

class ContinueSimulationCommand {
  const ContinueSimulationCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  Future<void> execute() async {
    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpSubteams]!,
    )) {
      SetUpSubteamsCommand(context: context, database: database).execute();
    }

    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpTraining]!,
    )) {
      await SetUpTrainingsCommand(context: context, database: database).execute();
    }

    final changedDate = database.currentDate.add(const Duration(days: 1));

    if (!context.mounted) return;
    //SimulateGlobalTrainingCommand(context: context, database: changedDb).execute();

    final changedDb = database.copyWith(currentDate: changedDate);
    context.read<SimulationDatabaseCubit>().update(changedDb);
  }
}
