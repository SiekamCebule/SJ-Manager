part of '../simulation_wizard_dialog.dart';

class _DynamicContent extends StatelessWidget {
  const _DynamicContent();

  @override
  Widget build(BuildContext context) {
    final screen = (context.watch<SimulationWizardNavigationCubit>().state
            as InitializedSimulationWizardNavigationState)
        .currentScreen;

    return ClipRect(
      child: AnimatedSwitcher(
        duration: Durations.medium1,
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) {
          final slide = CurvedAnimation(parent: animation, curve: Curves.easeInOut).drive(
            Tween(begin: const Offset(-1, 0), end: Offset.zero),
          );
          return SlideTransition(
            position: slide,
            child: child,
          );
        },
        child: switch (screen) {
          SimulationWizardScreen.mode => _ModeScreen(onChange: (mode) {
              context.read<SimulationSetupConfig>().mode = mode;
            }),
          SimulationWizardScreen.country => const _CountryScreen(),
          _ => const Placeholder(),
        },
      ),
    );
  }
}
