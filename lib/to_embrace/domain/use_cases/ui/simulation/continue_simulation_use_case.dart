import 'dart:async';

import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/jumper_reports/create_monthly_training_progress_reports_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/jumper_reports/create_weekly_training_progress_reports_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/set_up_subteams_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/set_up_trainings_command.dart';
import 'package:sj_manager/to_embrace/domain/use_cases/ui/simulation/training/simulate_global_training_command.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/actions/simulation_action_type.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/core/general_utils/datetime.dart';

class ContinueSimulationUseCase {
  const ContinueSimulationUseCase({
    required this.database,
    required this.chooseSubteamId,
    required this.afterSettingUpSubteams,
    required this.afterSettingUpTrainings,
  });

  final SimulationDatabase database;

  final String Function(Subteam subteam) chooseSubteamId;
  final FutureOr Function()? afterSettingUpSubteams;
  final FutureOr Function()? afterSettingUpTrainings;

  void execute() {
    if (isSameDay(
      today: database.currentDate,
      targetDate: database.actionDeadlines[SimulationActionType.settingUpSubteams]!,
    )) {
      SetUpSubteamsCommand(
        database: database,
        chooseSubteamId: chooseSubteamId,
        onFinish: afterSettingUpTrainings,
      ).execute();
    }

    final date = database.currentDate;
    if (database.actionsRepo.isCompleted(SimulationActionType.settingUpTraining)) {
      SimulateGlobalTrainingCommand(
        database: database,
      ).execute();

      if (date.weekday == DateTime.sunday) {
        CreateWeeklyTrainingProgressReportsCommand(
          database: database,
        ).execute();
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
      SetUpTrainingsCommand(
        database: database,
        onFinish: afterSettingUpTrainings,
      ).execute();
    }
    database.currentDate = database.currentDate.add(const Duration(days: 1));
    database.notify();
  }
}
