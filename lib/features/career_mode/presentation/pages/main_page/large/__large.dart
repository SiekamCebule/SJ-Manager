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
            exit: () async => await _exitSimulation(),
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
                        '/simulation/home' => buildPageRoute(widget: const _HomePage()),
                        '/simulation/team' => buildPageRoute(
                              widget: _TeamPage(
                            initialMode: settings.arguments as TeamScreenMode,
                          )),
                        '/simulation/teams' => buildPageRoute(
                            widget: const _TeamsPage(
                              initialSex: SelectedSex.both,
                            ),
                          ),
                        '/simulation/jumpers' => buildPageRoute(
                            widget: const _JumpersPage(
                              initialSex: SelectedSex.male,
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

  Future<void> _exitSimulation() async {
    final bool? saveChanges = await showSjmDialog(
      barrierDismissible: true,
      context: context,
      child: const SimulationExitAreYouSureDialog(),
    );
    if (!mounted) return;
    if (saveChanges == false) {
      router.pop(context);
    } else if (saveChanges == true) {
      if (!context.mounted) return;
      //await context.read<SimulationCubit>().preserve(); TODO
      router.pop(context);
    }
  }
}
