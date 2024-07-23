part of '../simulation_wizard_dialog.dart';

class _Footer extends StatefulWidget {
  const _Footer();

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  @override
  Widget build(BuildContext context) {
    final currentScreenCubit = context.watch<SimulationWizardNavigationCubit>();
    final currentScreenState = currentScreenCubit.state;

    return SizedBox(
      height: 70,
      child: ClipRect(
        child: MainMenuCard(
          child: Row(
            children: [
              Visibility(
                maintainState: false,
                visible:
                    currentScreenState is InitializedSimulationWizardNavigationState &&
                        currentScreenState.canGoBack,
                child: SizedBox(
                  width: 80,
                  child: IconButton(
                    onPressed: () {
                      currentScreenCubit.goBack();
                    },
                    icon: const Icon(Symbols.arrow_back),
                    style: IconButton.styleFrom(iconSize: 35),
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                maintainState: false,
                visible:
                    currentScreenState is InitializedSimulationWizardNavigationState &&
                        currentScreenState.canGoForward,
                child: SizedBox(
                  width: 80,
                  child: IconButton(
                    onPressed: () {
                      currentScreenCubit.goForward();
                    },
                    icon: const Icon(Symbols.arrow_forward),
                    style: IconButton.styleFrom(iconSize: 35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
