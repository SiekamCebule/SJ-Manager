import 'dart:async';

import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/repository/simulation_actions_repository.dart';
import 'package:sj_manager/features/career_mode/subfeatures/current_date/domain/repository/simulation_current_date_repository.dart';
import 'package:sj_manager/to_embrace/domain/continue/subcases/reports/monthly/set_up_monthly_training_reports_use_case.dart';
import 'package:sj_manager/to_embrace/domain/continue/subcases/reports/weekly/set_up_weekly_training_reports_use_case.dart';
import 'package:sj_manager/to_embrace/domain/continue/subcases/set_up_subteams_use_case.dart';
import 'package:sj_manager/to_embrace/domain/continue/subcases/training/simulate_global_training_subcase.dart';
import 'package:sj_manager/to_embrace/domain/continue/subcases/training/set_up_trainings_subcase.dart';
import 'package:sj_manager/features/career_mode/subfeatures/actions/domain/entities/simulation_action_type.dart';
import 'package:sj_manager/core/general_utils/datetime.dart';

class ContinueSimulationUseCase {
  const ContinueSimulationUseCase({
    required this.currentDateRepository,
    required this.actionsRepository,
    required this.setUpSubteams,
    required this.setUpTrainings,
    required this.setUpWeeklyTrainingReports,
    required this.setUpMonthlyTrainingReports,
    required this.simulateGlobalTraining,
  });

  final SimulationCurrentDateRepository currentDateRepository;
  final SimulationActionsRepository actionsRepository;

  final SetUpSubteamsUseCase setUpSubteams;
  final SetUpTrainingsSubcase setUpTrainings;
  final SetUpWeeklyTrainingReportsUseCase setUpWeeklyTrainingReports;
  final SetUpMonthlyTrainingReportsUseCase setUpMonthlyTrainingReports;
  final SimulateGlobalTrainingSubcase simulateGlobalTraining;

  Future<void> execute() async {
    Future<DateTime> currentDate() async => await currentDateRepository.get();
    final settingUpSubteamsDeadline =
        (await actionsRepository.actionByType(SimulationActionType.settingUpSubteams))
            .deadline!;
    final settingUpTrainingsDeadline =
        (await actionsRepository.actionByType(SimulationActionType.settingUpTraining))
            .deadline!;
    if (isSameDay(
      today: await currentDate(),
      targetDate: settingUpSubteamsDeadline,
    )) {
      await setUpSubteams();
    }

    if (await actionsRepository.isCompleted(SimulationActionType.settingUpTraining)) {
      await simulateGlobalTraining();

      if ((await currentDate()).weekday == DateTime.sunday) {
        await setUpWeeklyTrainingReports();
      }
      if ((await currentDate()).day ==
          daysInMonth((await currentDate()).year, (await currentDate()).month)) {
        await setUpMonthlyTrainingReports();
      }
    }

    if (isSameDay(
      today: await currentDate(),
      targetDate: settingUpTrainingsDeadline,
    )) {
      await setUpSubteams();
    }
    await currentDateRepository.set((await currentDate()).add(const Duration(days: 1)));
  }
}
