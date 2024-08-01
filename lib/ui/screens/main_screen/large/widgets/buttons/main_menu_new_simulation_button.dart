part of '../../../main_screen.dart';

class MainMenuNewSimulationButton extends StatelessWidget {
  const MainMenuNewSimulationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainMenuCard(
      onTap: () async {
        // TODO: Add dialog dimensions to UI constants
        final shouldCreateSimulation = await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.9),
          barrierLabel: 'dismiss new simulation dialog',
          pageBuilder: (context, animationIn, animationOut) {
            return const Center(
              child: SizedBox(
                width: 1000,
                height: 650,
                child: SimulationWizardDialog(),
              ),
            );
          },
          transitionDuration: Durations.medium1,
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            final fadeIn =
                CurvedAnimation(parent: animation, curve: Curves.easeInOutCirc);
            final fadeOut = CurvedAnimation(
                    parent: secondaryAnimation, curve: Curves.easeOutCirc)
                .drive(Tween(begin: 1.0, end: 0.0));
            return FadeTransition(
              opacity: fadeIn,
              child: FadeTransition(
                opacity: fadeOut,
                child: child,
              ),
            );
          },
        );
        print('shouldCreateSimulation: $shouldCreateSimulation');
      },
      child: MainMenuTextContentButtonBody(
        titleText: translate(context).newSimulation,
        contentText: translate(context).newSimulationButtonContent,
      ),
    );
  }
}
