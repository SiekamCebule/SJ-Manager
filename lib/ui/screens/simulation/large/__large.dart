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
    return Scaffold(
      body: Row(
        children: [
          _NavigationRail(navigatorKey: _navigatorKey),
          const Gap(25),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(5),
                SizedBox(
                  height: 50,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      const SizedBox(
                        width: 120,
                        child: _CurrentDateCard(),
                      ),
                      const Gap(6),
                      SimulationRouteMainActionButton(
                        labelText: 'Kontynuuj', // or "Dom"
                        iconData: Symbols.forward, // or "home"
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Navigator(
                    key: _navigatorKey,
                    initialRoute: '/simulation/home',
                    onGenerateRoute: (settings) {
                      return switch (settings.name) {
                        '/simulation/home' =>
                          MaterialPageRoute(builder: (context) => const _HomeScreen()),
                        '/simulation/team' =>
                          MaterialPageRoute(builder: (context) => const _TeamScreen()),
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
