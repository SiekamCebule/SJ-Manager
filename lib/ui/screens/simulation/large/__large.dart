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
                  child: _TopPanel(navigatorKey: _navigatorKey),
                ),
                const Gap(5),
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
