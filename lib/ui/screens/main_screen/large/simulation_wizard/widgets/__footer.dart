part of '../simulation_wizard_dialog.dart';

class _Footer extends StatefulWidget {
  const _Footer();

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  @override
  Widget build(BuildContext context) {
    final navCubit = context.watch<SimulationWizardNavigationCubit>();
    final selectedOptions = context.watch<SimulationWizardOptionsRepo>();

    return SizedBox(
      height: 70,
      child: ClipRect(
        child: MainMenuCard(
          child: StreamBuilder(
              stream: selectedOptions.changes,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    Visibility(
                      maintainAnimation: true,
                      maintainSize: true,
                      maintainState: true,
                      maintainInteractivity: false,
                      visible: navCubit.state.canGoBack,
                      child: SizedBox(
                        width: 80,
                        child: IconButton(
                          onPressed: () {
                            navCubit.goBack();
                          },
                          icon: const Icon(Symbols.arrow_back),
                          style: IconButton.styleFrom(iconSize: 35),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Visibility(
                      maintainAnimation: true,
                      maintainSize: true,
                      maintainState: true,
                      maintainInteractivity: false,
                      visible: navCubit.state.canGoForward,
                      child: SizedBox(
                        width: 80,
                        child: IconButton(
                          onPressed: () {
                            navCubit.goForward();
                          },
                          icon: const Icon(Symbols.arrow_forward),
                          style: IconButton.styleFrom(iconSize: 35),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
