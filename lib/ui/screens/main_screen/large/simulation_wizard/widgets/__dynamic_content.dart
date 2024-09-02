part of '../simulation_wizard_dialog.dart';

class _DynamicContent extends StatelessWidget {
  const _DynamicContent();

  @override
  Widget build(BuildContext context) {
    final navCubit = context.watch<SimulationWizardNavigationCubit>();

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
        child: switch (navCubit.state.screen) {
          SimulationWizardScreen.mode => _ModeScreen(onChange: (mode) {
              context.read<SimulationWizardOptionsRepo>().mode.set(mode);
              if (mode != null) {
                navCubit.unblockGoingForward();
              } else {
                navCubit.blockGoingForward();
              }
            }),
          SimulationWizardScreen.team => _TeamScreen(
              onChange: (team) {
                context.read<SimulationWizardOptionsRepo>().team.set(team);
                if (team != null) {
                  navCubit.unblockGoingForward();
                } else {
                  navCubit.blockGoingForward();
                }
              },
            ),
          _ => const Placeholder(),
        },
      ),
    );
  }
}
