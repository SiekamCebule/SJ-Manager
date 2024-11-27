part of '../simulation_route.dart';

class _TopPanel extends StatelessWidget {
  const _TopPanel({
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final actionsState =
        context.watch<SimulationActionsCubit>().state as SimulationActionsDefault;
    final currentDateState =
        context.watch<SimulationCurrentDateCubit>() as SimulationCurrentDateDefault;
    final navigationState = context.watch<SimulationScreenNavigationCubit>().state;
    final homeIsSelected =
        navigationState.screen == SimulationScreenNavigationTarget.home;
    final mainButtonText = homeIsSelected ? 'Kontynuuj' : 'Dom';
    final mainButtonIconData = homeIsSelected ? Symbols.forward : Symbols.home;

    void returnToHome() {
      navigatorKey.currentState!.pushReplacementNamed('/simulation/home');
      context
          .read<SimulationScreenNavigationCubit>()
          .change(screen: SimulationScreenNavigationTarget.home);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        for (var action in actionsState.sortedIncompletedActions) ...[
          _UpcomingSimulationActionCard(
            important: actionsState.deadline[action.type]!
                    .difference(currentDateState.currentDate) <
                const Duration(hours: 48),
            actionType: action.type,
            deadline: action.deadline,
            onTap: () async {
              late Widget dialogWidget;
              dialogWidget = switch (action.type) {
                SimulationActionType.settingUpTraining => TrainingsSettingUpHelpDialog(
                    trainingsStartDate:
                        actionsState.deadline[SimulationActionType.settingUpTraining]!,
                  ),
                SimulationActionType.settingUpSubteams => SubteamsSettingUpHelpDialog(
                    subteamsSetuppingDate:
                        actionsState.deadline[SimulationActionType.settingUpSubteams]!,
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
        if (actionsState.sortedIncompletedActions.isNotEmpty) const Gap(70),
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
                    await ContinueSimulationUseCase(
                      database: database,
                      chooseSubteamId: (subteam) =>
                          context.read<IdGenerator>().generate(),
                      afterSettingUpTrainings: () async {
                        await SetUpTrainingsSubcase(
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
                                        value: context.read<CountryFlagsRepository>()),
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
                        await SetUpSubteamsUseCase(
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
                                  Provider.value(
                                      value: context.read<CountryFlagsRepository>()),
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
