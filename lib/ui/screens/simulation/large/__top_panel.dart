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
                      context: context,
                      database: database,
                      navigatorKey: navigatorKey,
                    ).execute();
                  }
                : returnToHome,
          ),
        ),
      ],
    );
  }
}
