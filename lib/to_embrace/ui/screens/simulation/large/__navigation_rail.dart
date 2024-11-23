part of '../simulation_route.dart';

class _NavigationRail extends StatefulWidget {
  const _NavigationRail({
    required this.navigatorKey,
    required this.exit,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final VoidCallback exit;

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
    final database = context.watch<SimulationDatabase>();
    final simulationMode = database.managerData.mode;

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
            'Kadra',
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
          icon: const Icon(Symbols.groups),
          label: Text(
            'Drużyny',
            style: regularRailDestinationLabelStyle,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.person_2_rounded),
          label: Text(
            'Zawodnicy',
            style: regularRailDestinationLabelStyle,
          ),
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.settings),
          label: Text(
            'Ustawienia',
            style: regularRailDestinationLabelStyle,
          ),
          disabled: true,
        ),
        NavigationRailDestination(
          icon: const Icon(Symbols.exit_to_app),
          label: Text(
            'Wyjdź',
            style: exitButtonStyle,
          ),
        ),
      ],
      selectedIndex: context.watch<SimulationScreenNavigationCubit>().state.screen.index,
      minWidth: 80,
      minExtendedWidth: 160,
      onDestinationSelected: (selecetedIndex) {
        final navigationTarget =
            navigationTargetsBySimulationMode[simulationMode]![selecetedIndex];
        switch (navigationTarget) {
          case SimulationScreenNavigationTarget.home:
            widget.navigatorKey.currentState!.pushReplacementNamed('/simulation/home');
          case SimulationScreenNavigationTarget.team:
            widget.navigatorKey.currentState!.pushReplacementNamed(
              '/simulation/team',
              arguments: TeamScreenMode.overview,
            );
          case SimulationScreenNavigationTarget.teams:
            widget.navigatorKey.currentState!.pushReplacementNamed(
              '/simulation/teams',
            );
          case SimulationScreenNavigationTarget.jumpers:
            widget.navigatorKey.currentState!.pushReplacementNamed(
              '/simulation/jumpers',
            );
          case SimulationScreenNavigationTarget.exit:
            widget.exit();
          default:
            throw ArgumentError(
              'Prosimy o zgłoszenie nam tego błędu. Próbowano przejść do ekranu $navigationTarget (niezaimplementowano)',
            );
        }
        if (navigationTarget != SimulationScreenNavigationTarget.exit) {
          context
              .read<SimulationScreenNavigationCubit>()
              .change(screen: navigationTarget);
        }
      },
    );
  }
}
