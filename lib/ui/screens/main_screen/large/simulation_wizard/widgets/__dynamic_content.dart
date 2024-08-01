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
          final slide =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut).drive(
            Tween(begin: const Offset(-1, 0), end: Offset.zero),
          );
          return SlideTransition(
            position: slide,
            child: child,
          );
        },
        child: switch (screen) {
          SimulationWizardScreen.mode => _ModeScreen(onChange: (mode) {
              context.read<SimulationWizardOptionsRepo>().mode.set(mode);
              if (mode != null) {
                updateCanGoForward(true, context);
              } else {
                updateCanGoForward(false, context);
              }
            }),
          SimulationWizardScreen.team => _TeamScreen(
              onChange: (team) {
                context.read<SimulationWizardOptionsRepo>().team.set(team);
                if (team != null) {
                  updateCanGoForward(true, context);
                } else {
                  updateCanGoForward(false, context);
                }
              },
            ),
          _ => const Placeholder(),
        },
      ),
    );
  }

  void updateCanGoForward(bool can, BuildContext context) {
    final navCubit = context.read<SimulationWizardNavigationCubit>();
    final navState = navCubit.state;
    if (navState is InitializedSimulationWizardNavigationState) {
      final navPermissions = context.read<LinearNavigationPermissionsRepo>();
      navPermissions.canGoForward = navState.indexAllowsGoingForward && can;
    }
  }

  void updateCanGoBack(bool can, BuildContext context) {
    final navCubit = context.read<SimulationWizardNavigationCubit>();
    final navState = navCubit.state;
    if (navState is InitializedSimulationWizardNavigationState) {
      final navPermissions = context.read<LinearNavigationPermissionsRepo>();
      navPermissions.canGoBack = navState.indexAllowsGoingBack && can;
    }
  }
}
