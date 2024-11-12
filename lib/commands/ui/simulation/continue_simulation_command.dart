import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/ui/simulation/jumper_reports/create_monthly_training_progress_reports_command.dart';
import 'package:sj_manager/commands/ui/simulation/jumper_reports/create_weekly_training_progress_reports_command.dart';
import 'package:sj_manager/commands/ui/simulation/set_up_subteams_command.dart';
import 'package:sj_manager/commands/ui/simulation/set_up_trainings_command.dart';
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
    final contextNotMountedException = StateError('Context is not mounted');
    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpSubteams]!,
    )) {
      await SetUpSubteamsCommand(context: context, database: database).execute();
      if (!context.mounted) throw contextNotMountedException;
    }

    if (!context.mounted) throw contextNotMountedException;
    final date = database.currentDate;
    if (database.actionsRepo.isCompleted(SimulationActionType.settingUpTraining)) {
      SimulateGlobalTrainingCommand(context: context, database: database).execute();
      if (date.weekday == DateTime.sunday) {
        CreateWeeklyTrainingProgressReportsCommand(database: database).execute();
      }
      if (date.day == daysInMonth(date.year, date.month)) {
        CreateMonthlyTrainingProgressReportsCommand(
          database: database,
          endedMonth: date.month,
          yearDuringEndedMonth: date.year,
        ).execute();
      }
    }

    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpTraining]!,
    )) {
      await SetUpTrainingsCommand(
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
    database.currentDate = database.currentDate.add(const Duration(days: 1));
    database.notify();
  }
}
