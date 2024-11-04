import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/jumper_reports/create_monthly_training_progress_reports_command.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/jumper_reports/create_weekly_training_progress_reports_command.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/set_up_subteams_command.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/set_up_trainings_command.dart';
import 'package:sj_manager/commands/simulation/common/simulation_database_cubit.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/training/simulate_global_training_command.dart';
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
    var database = this.database;
    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpSubteams]!,
    )) {
      database = SetUpSubteamsCommand(context: context, database: database).execute();
    }

    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpTraining]!,
    )) {
      database =
          await SetUpTrainingsCommand(context: context, database: database).execute();
    }

    if (!context.mounted) return;
    final date = database.currentDate;
    if (database.actionsRepo.isCompleted(SimulationActionType.settingUpTraining)) {
      database =
          SimulateGlobalTrainingCommand(context: context, database: database).execute();
    }
    if (date.weekday == DateTime.sunday) {
      await CreateWeeklyTrainingProgressReportsCommand(database: database).execute();
    }
    if (date.day == daysInMonth(date.year, date.month)) {
      database =
          await CreateMonthlyTrainingProgressReportsCommand(database: database).execute();
    }

    database = database.copyWith(currentDate: date.add(const Duration(days: 1)));
    if (!context.mounted) return;
    context.read<SimulationDatabaseCubit>().update(database);
  }
}
