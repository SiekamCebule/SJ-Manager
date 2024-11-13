part of '../simulation_route.dart';

class _TopPanel extends StatelessWidget {
  const _TopPanel({
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<SimulationDatabase>();
    const availableActions = SimulationActionType.values;
    final incompletedActions =
        availableActions.where(database.actionsRepo.isNotCompleted);
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
          width: 165,
          child: _CurrentDateCard(),
        ),
        const Gap(10),
        SizedBox(
          height: double.infinity,
          width: 190,
          child: SimulationRouteMainActionButton(
            labelText: mainButtonText,
            iconData: mainButtonIconData,
            onPressed: homeIsSelected
                ? () async {
                    await ContinueSimulationCommand(
                      database: database,
                      chooseSubteamId: (subteam) =>
                          context.read<IdGenerator>().generate(),
                      afterSettingUpTrainings: () async {
                        await SetUpTrainingsCommand(
                          database: database,
                          onFinish: () async {
                            final dbHelper = context.read<SimulationDatabaseHelper>();
                            await showSjmDialog(
                              barrierDismissible: false,
                              context: context,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: MultiProvider(
                                  providers: [
                                    Provider.value(
                                        value: context.read<CountryFlagsRepo>()),
                                    Provider.value(
                                        value: context.read<
                                            DbItemImageGeneratingSetup<
                                                SimulationJumper>>()),
                                    ChangeNotifierProvider.value(value: database),
                                  ],
                                  child: SetUpTrainingsDialog(
                                    simulationMode: database.managerData.mode,
                                    jumpers: dbHelper.managerJumpers,
                                    jumpersSimulationRatings: dbHelper.jumperReportsMap,
                                    onSubmit: (result) {
                                      if (result ==
                                          SetUpTrainingsDialogResult.goToTrainingView) {
                                        navigatorKey.currentState!.pushReplacementNamed(
                                          '/simulation/team',
                                          arguments: TeamScreenMode.training,
                                        );
                                        context
                                            .read<SimulationScreenNavigationCubit>()
                                            .change(
                                              screen:
                                                  SimulationScreenNavigationTarget.team,
                                            );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ).execute();
                      },
                      afterSettingUpSubteams: () async {
                        final dbHelper = context.read<SimulationDatabaseHelper>();
                        final charges = dbHelper.managerJumpers;
                        await SetUpSubteamsCommand(
                          database: database,
                          chooseSubteamId: (subteam) =>
                              context.read<IdGenerator>().generate(),
                          onFinish: () async {
                            await showSjmDialog(
                              context: context,
                              barrierDismissible: true,
                              child: MultiProvider(
                                providers: [
                                  Provider.value(
                                      value: context.read<
                                          DbItemImageGeneratingSetup<
                                              SimulationJumper>>()),
                                  Provider.value(value: context.read<CountryFlagsRepo>()),
                                ],
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  child: SubteamsSettingUpPersonalCoachDialog(
                                    jumpers: charges,
                                    subteamType: {
                                      for (final charge in charges)
                                        charge: dbHelper.subteamOfJumper(charge)!,
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ).execute();
                      },
                    ).execute();
                  }
                : returnToHome,
          ),
        ),
      ],
    );
  }
}
