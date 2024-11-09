import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/ui/simulation/jumper_reports/create_monthly_training_progress_reports_command.dart';
import 'package:sj_manager/commands/ui/simulation/jumper_reports/create_weekly_training_progress_reports_command.dart';
import 'package:sj_manager/commands/ui/simulation/set_up_subteams_command.dart';
import 'package:sj_manager/commands/ui/simulation/set_up_trainings_command.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/commands/ui/simulation/simulation_screen_navigation_cubit.dart';
import 'package:sj_manager/commands/ui/simulation/training/simulate_global_training_command.dart';
import 'package:sj_manager/models/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/ui/screens/simulation/large/dialogs/set_up_trainings/set_up_trainings_dialog.dart';
import 'package:sj_manager/ui/screens/simulation/simulation_route.dart';
import 'package:sj_manager/utils/datetime.dart';

class ContinueSimulationCommand {
  const ContinueSimulationCommand({
    required this.context,
    required this.database,
    required this.navigatorKey,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final GlobalKey<NavigatorState> navigatorKey;

  Future<void> execute() async {
    var database = this.database;
    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpSubteams]!,
    )) {
      database =
          await SetUpSubteamsCommand(context: context, database: database).execute();
      if (!context.mounted) return;
    }

    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpTraining]!,
    )) {
      database = await SetUpTrainingsCommand(
        context: context,
        database: database,
        onFinish: (result) {
          if (result == SetUpTrainingsDialogResult.goToTrainingView) {
            navigatorKey.currentState!.pushReplacementNamed(
              '/simulation/team',
              arguments: TeamScreenMode.training,
            );
            context
                .read<SimulationScreenNavigationCubit>()
                .change(screen: SimulationScreenNavigationTarget.team);
          }
        },
      ).execute();
    }

    if (!context.mounted) return;
    final date = database.currentDate;
    if (database.actionsRepo.isCompleted(SimulationActionType.settingUpTraining)) {
      database =
          SimulateGlobalTrainingCommand(context: context, database: database).execute();
      if (date.weekday == DateTime.sunday) {
        database =
            CreateWeeklyTrainingProgressReportsCommand(database: database).execute();
      }
      if (date.day == daysInMonth(date.year, date.month)) {
        database = CreateMonthlyTrainingProgressReportsCommand(
          database: database,
          endedMonth: date.month,
          yearDuringEndedMonth: date.year,
        ).execute();
      }
    }

    database = database.copyWith(currentDate: date.add(const Duration(days: 1)));
    if (!context.mounted) return;
    context.read<SimulationDatabaseCubit>().update(database);
  }
}
