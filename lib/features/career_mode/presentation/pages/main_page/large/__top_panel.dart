part of '../simulation_route.dart';

class _TopPanel extends StatelessWidget {
  const _TopPanel({
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final simulationState =
        context.watch<SimulationCubit>().state as SimulationInitialized;
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
        for (var action in simulationState.pendingActions) ...[
          _UpcomingSimulationActionCard(
            important: simulationState.actionDeadline[action.type]!
                    .difference(simulationState.currentDate) <
                const Duration(hours: 48),
            actionType: action.type,
            deadline: action.deadline,
            onTap: () async {
              late Widget dialogWidget;
              dialogWidget = switch (action.type) {
                SimulationActionType.settingUpTraining => TrainingsSettingUpHelpDialog(
                    trainingsStartDate: simulationState
                        .actionDeadline[SimulationActionType.settingUpTraining]!,
                  ),
                SimulationActionType.settingUpSubteams => SubteamsSettingUpHelpDialog(
                    subteamsSetuppingDate: simulationState
                        .actionDeadline[SimulationActionType.settingUpSubteams]!,
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
        if (simulationState.pendingActions.isNotEmpty) const Gap(70),
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
                    await context
                        .read<SimulationCubit>()
                        .advance(const Duration(days: 1));
                    final setUpTrainingsDialogResult = await showSetUpTrainingsDialog(
                      context: context,
                    );
                    if (setUpTrainingsDialogResult ==
                        SetUpTrainingsDialogResult.goToTrainingView) {
                      navigatorKey.currentState!.pushReplacementNamed(
                        '/simulation/team',
                        arguments: TeamScreenMode.training,
                      );
                      context.read<SimulationScreenNavigationCubit>().change(
                            screen: SimulationScreenNavigationTarget.team,
                          );
                    }
                    await showSubteamsSetUpPersonalCoachDialog(context: context);
                  }
                : returnToHome,
          ),
        ),
      ],
    );
  }
}
