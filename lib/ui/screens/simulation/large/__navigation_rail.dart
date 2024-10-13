part of '../simulation_route.dart';

class _NavigationRail extends StatefulWidget {
  const _NavigationRail({
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<_NavigationRail> createState() => _NavigationRailState();
}

class _NavigationRailState extends State<_NavigationRail> {
  @override
  Widget build(BuildContext context) {
    final regularRailDestinationLabelStyle = Theme.of(context).textTheme.bodySmall!;
    final exitButtonStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.onErrorContainer,
        );
    return NavigationRail(
      extended: true,
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Symbols.home),
          label: Text(
            'Dom',
            style: regularRailDestinationLabelStyle,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.group),
          label: Text(
            'Drużyna',
            style: regularRailDestinationLabelStyle,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.trophy),
          label: Text(
            'Klasyfikacje',
            style: regularRailDestinationLabelStyle,
          ),
          disabled: true,
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.archive),
          label: Text(
            'Archiwum',
            style: regularRailDestinationLabelStyle,
          ),
          disabled: true,
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.calendar_month),
          label: Text(
            'Kalendarz',
            style: regularRailDestinationLabelStyle,
          ),
          disabled: true,
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.analytics),
          label: Text(
            'Statystyki',
            style: regularRailDestinationLabelStyle,
          ),
          disabled: true,
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.settings),
          label: Text(
            'Ustawienia',
            style: regularRailDestinationLabelStyle,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.exit_to_app),
          label: Text(
            'Wyjdź',
            style: exitButtonStyle,
          ),
        ),
      ],
      selectedIndex: context.watch<SimulationScreenNavigationCubit>().state.screenIndex,
      minWidth: 80,
      minExtendedWidth: 150,
      onDestinationSelected: (selecetedIndex) {
        switch (selecetedIndex) {
          case 0:
            widget.navigatorKey.currentState!.pushNamed('/simulation/home');
          case 1:
            widget.navigatorKey.currentState!.pushNamed('/simulation/team');
          case 7:
            router.pop(context);
        }
        if (selecetedIndex != 7) {
          context.read<SimulationScreenNavigationCubit>().change(index: selecetedIndex);
        }
      },
    );
  }
}
