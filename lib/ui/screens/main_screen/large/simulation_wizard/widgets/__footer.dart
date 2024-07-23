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
    final navCubitState = navCubit.state;
    final navPermissions = context.watch<LinearNavigationPermissionsRepo>();
    final selectedOptions = context.watch<SimulationWizardOptionsRepo>();

    return SizedBox(
      height: 70,
      child: ClipRect(
        child: MainMenuCard(
          child: StreamBuilder(
              stream: selectedOptions.countryStream,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                        stream: navPermissions.canGoBackStream,
                        builder: (context, snapshot) {
                          print('can go back: ${navPermissions.canGoBack}');

                          return Visibility(
                            maintainState: false,
                            visible: navPermissions.canGoBack,
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
                          );
                        }),
                    if (navCubitState is InitializedSimulationWizardNavigationState &&
                        navCubitState.currentScreen == SimulationWizardScreen.country &&
                        selectedOptions.country != null)
                      Center(
                        child: SelectedCountryCaption(
                          country: selectedOptions.country!,
                          stars: 5, // TODO: Calculate stars
                        ),
                      ),
                    StreamBuilder(
                        stream: navPermissions.canGoForwardStream,
                        builder: (context, snapshot) {
                          return Visibility(
                            maintainState: false,
                            visible: navPermissions.canGoForward,
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
                          );
                        }),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
