part of '../simulation_route.dart';

class _TopPanel extends StatelessWidget {
  const _TopPanel({
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabaseCubit>().state;
    final dbHelper = context.read<SimulationDatabaseHelper>();
    final availableActions = possibleActionsBySimulationMode[database.managerData.mode]!;
    final incompletedActions = availableActions.where(database.actionsRepo.isIncompleted);
    final sortedIncompletedActions = incompletedActions.sorted(
      (first, second) {
        return database.actionDeadlines[second]!
            .compareTo(database.actionDeadlines[first]!);
      },
    );
    final navigationCubit = context.watch<SimulationScreenNavigationCubit>();
    final homeIsSelected =
        navigationCubit.state.screen == SimulationScreenNavigationTarget.home;
    final mainButtonText = homeIsSelected ? 'Kontynuuj' : 'Dom';
    final mainButtonIconData = homeIsSelected ? Symbols.forward : Symbols.home;

    void returnToHome() {
      navigatorKey.currentState!.pushReplacementNamed('/simulation/home');
      navigationCubit.change(screen: SimulationScreenNavigationTarget.home);
    }

    void continueSimulation() async {
      final changedDate = database.currentDate.add(const Duration(days: 1));
      final changedDb = database.copyWith(currentDate: changedDate);
      context.read<SimulationDatabaseCubit>().update(changedDb);

      if (isSameDay(
        today: changedDate,
        targetDate: database.actionDeadlines[SimulationActionType.settingUpSubteams]!,
      )) {
        database.actionsRepo.complete(SimulationActionType.settingUpSubteams);
      }

      if (isSameDay(
        today: changedDate,
        targetDate: database.actionDeadlines[SimulationActionType.settingUpTraining]!,
      )) {
        await showSjmDialog(
          barrierDismissible: false,
          context: context,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SetUpTrainingsDialog(
              simulationMode: database.managerData.mode,
              jumpers: dbHelper.managerJumpers,
              jumpersSimulationRatings: database.jumpersReports,
              managerPointsCount: database.managerData.trainingPoints,
              onSubmit: (configs) {
                final dynamicParams = Map.of(database.jumpersDynamicParameters);
                configs.forEach((jumper, trainingConfig) {
                  dynamicParams[jumper] =
                      dynamicParams[jumper]!.copyWith(trainingConfig: trainingConfig);
                });
                final changedDatabase =
                    changedDb.copyWith(jumpersDynamicParameters: dynamicParams);
                context.read<SimulationDatabaseCubit>().update(changedDatabase);
              },
            ),
          ),
        );
        database.actionsRepo.complete(SimulationActionType.settingUpTraining);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        for (var incompletedActionType in sortedIncompletedActions) ...[
          _UpcomingSimulationActionCard(
            important: database.actionDeadlines[incompletedActionType]!
                    .difference(database.currentDate) <
                const Duration(hours: 48),
            actionType: incompletedActionType,
            onTap: () async {
              late Widget dialogWidget;
              dialogWidget = switch (incompletedActionType) {
                SimulationActionType.settingUpTraining => TrainingsSettingUpHelpDialog(
                    trainingsStartDate:
                        database.actionDeadlines[SimulationActionType.settingUpTraining]!,
                  ),
                SimulationActionType.settingUpSubteams => SubteamsSettingUpHelpDialog(
                    subteamsSetuppingDate:
                        database.actionDeadlines[SimulationActionType.settingUpSubteams]!,
                  ),
              };
              await showSjmDialog(
                barrierDismissible: true,
                context: context,
                child: dialogWidget,
              );
            },
          ),
          const Gap(10),
        ],
        if (sortedIncompletedActions.isNotEmpty) const Gap(70),
        const SizedBox(
          width: 120,
          child: _CurrentDateCard(),
        ),
        const Gap(10),
        SizedBox(
          height: double.infinity,
          width: 190,
          child: SimulationRouteMainActionButton(
            labelText: mainButtonText,
            iconData: mainButtonIconData,
            onPressed: homeIsSelected ? continueSimulation : returnToHome,
          ),
        ),
      ],
    );
  }
}
