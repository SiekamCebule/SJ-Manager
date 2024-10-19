part of '../simulation_route.dart';

class _Large extends StatefulWidget {
  const _Large();

  @override
  State<_Large> createState() => _LargeState();
}

class _LargeState extends State<_Large> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    PageRouteBuilder buildPageRoute({required Widget widget}) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return widget;
        },
        transitionDuration: const Duration(milliseconds: 0),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          _NavigationRail(
            navigatorKey: _navigatorKey,
            exit: _exit,
          ),
          const Gap(25),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(5),
                SizedBox(
                  height: 50,
                  child: _TopPanel(navigatorKey: _navigatorKey),
                ),
                const Gap(5),
                Expanded(
                  child: Navigator(
                    key: _navigatorKey,
                    initialRoute: '/simulation/home',
                    onGenerateRoute: (settings) {
                      return switch (settings.name) {
                        '/simulation/home' => buildPageRoute(widget: const _HomeScreen()),
                        '/simulation/team' => buildPageRoute(widget: const _TeamScreen()),
                        _ => null,
                      };
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exit() async {
    final bool? saveChanges = await showSjmDialog(
      barrierDismissible: true,
      context: context,
      child: const SimulationExitAreYouSureDialog(),
    );
    if (saveChanges == false) {
      _exitWithoutSaving();
    } else if (saveChanges == true) {
      _exitWithSaving();
    }
  }

  void _exitWithoutSaving() {
    _cleanUpAndPop();
  }

  void _exitWithSaving() async {
    final pathsCache = context.read<PlarformSpecificPathsCache>();
    final pathsRegistry = context.read<DbItemsFilePathsRegistry>();
    final simulations = context.read<EditableItemsRepo<UserSimulation>>();
    final simulation = context.read<UserSimulation>();
    final database = context.read<SimulationDatabaseCubit>().state;

    await DefaultSimulationDatabaseSaverToFile(
      pathsRegistry: pathsRegistry,
      pathsCache: pathsCache,
      idsRepo: database.idsRepo,
      simulationId: simulation.id,
    ).serialize(database: database);

    await UserSimulationsRegistrySaverToFile(
      userSimulations: simulations.last.toList(),
      pathsCache: pathsCache,
    ).serialize();

    _cleanUpAndPop();
  }

  void _cleanUpAndPop() {
    context.read<SimulationDatabaseCubit>().state.dispose();
    context.read<SimulationDatabaseHelper>().dispose();
    router.pop(context);
  }
}
