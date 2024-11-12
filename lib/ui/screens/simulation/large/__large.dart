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
    final database = context.watch<SimulationDatabase>();

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
            exit: () =>
                SimulationExitCommand(context: context, database: database).execute(),
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
                        '/simulation/team' => buildPageRoute(
                              widget: _TeamScreen(
                            initialMode: settings.arguments as TeamScreenMode,
                          )),
                        '/simulation/teams' => buildPageRoute(
                            widget: const _TeamsScreen(
                              initialSex: TeamsScreenSelectedSex.both,
                            ),
                          ),
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
}
