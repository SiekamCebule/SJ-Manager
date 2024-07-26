part of '../simulation_wizard_dialog.dart';

class _Footer extends StatefulWidget {
  const _Footer();

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  @override
  Widget build(BuildContext context) {
    final navCubit = context.watch<SimulationWizardNavigationCubit>();
    final navCubitState = navCubit.state;
    final navPermissions = context.watch<LinearNavigationPermissionsRepo>();
    final selectedOptions = context.watch<SimulationWizardOptionsRepo>();

    final shouldShowDatabaseInfo =
        (navCubitState is InitializedSimulationWizardNavigationState) &&
            navCubitState.currentScreen == SimulationWizardScreen.team;

    return SizedBox(
      height: 70,
      child: ClipRect(
        child: MainMenuCard(
          child: StreamBuilder(
              stream: selectedOptions.changes,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    StreamBuilder(
                        stream: navPermissions.canGoBackStream,
                        builder: (context, snapshot) {
                          return Visibility(
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainState: true,
                            maintainInteractivity: false,
                            visible: navPermissions.canGoBack,
                            child: SizedBox(
                              width: 80,
                              child: IconButton(
                                onPressed: () {
                                  navCubit.goBack();
                                },
                                icon: const Icon(Symbols.arrow_back),
                                style: IconButton.styleFrom(iconSize: 35),
                              ),
                            ),
                          );
                        }),
                    const Spacer(),
                    if (shouldShowDatabaseInfo) ...[
                      TextButton(
                        onPressed: () async {
                          final db = await pickDatabaseByDialog(context);
                          if (db != null) {
                            selectedOptions.database.set(db);
                            selectedOptions.databaseIsExternal.set(true);
                          }
                        },
                        child: const Text('Wczytaj bazę danych'),
                      ),
                    ],
                    const Spacer(),
                    StreamBuilder(
                        stream: navPermissions.canGoForwardStream,
                        builder: (context, snapshot) {
                          return Visibility(
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainState: true,
                            maintainInteractivity: false,
                            visible: navPermissions.canGoForward,
                            child: SizedBox(
                              width: 80,
                              child: IconButton(
                                onPressed: () {
                                  navCubit.goForward();
                                },
                                icon: const Icon(Symbols.arrow_forward),
                                style: IconButton.styleFrom(iconSize: 35),
                              ),
                            ),
                          );
                        }),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
