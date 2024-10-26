import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/commands/simulation_flow/set_up_subteams_command.dart';
import 'package:sj_manager/bloc/simulation/commands/simulation_flow/set_up_trainings_command.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
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
    final changedDate = database.currentDate.add(const Duration(days: 1));
    final changedDb = database.copyWith(currentDate: changedDate);

    if (isSameDay(
      today: changedDate,
      targetDate: changedDb.actionDeadlines[SimulationActionType.settingUpSubteams]!,
    )) {
      SetUpSubteamsCommand(context: context, database: changedDb).execute();
    }

    if (isSameDay(
      today: changedDate,
      targetDate: changedDb.actionDeadlines[SimulationActionType.settingUpTraining]!,
    )) {
      await SetUpTrainingsCommand(context: context, database: changedDb).execute();
    }

    if (!context.mounted) return;
    //SimulateGlobalTrainingCommand(context: context, database: changedDb).execute();

    context.read<SimulationDatabaseCubit>().update(changedDb);
  }
}
