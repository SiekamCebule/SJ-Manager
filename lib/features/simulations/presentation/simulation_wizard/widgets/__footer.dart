part of '../pages/simulation_wizard_dialog.dart';

class _Footer extends StatefulWidget {
  const _Footer();

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  @override
  Widget build(BuildContext context) {
    final navCubit = context.watch<SimulationWizardNavigationCubit>();

    return SizedBox(
      height: 70,
      child: ClipRect(
        child: MainMenuCard(
          child: Row(
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
                  width: 200,
                  child: TextButton.icon(
                    onPressed: () {
                      navCubit.goForward();
                    },
                    label: navCubit.state.nextScreen != null
                        ? Text(
                            briefScreenDescription(
                              context: context,
                              screenType: navCubit.state.nextScreen!,
                            ),
                          )
                        : const Text('Zacznij grę'),
                    icon: Icon(
                      Symbols.arrow_forward,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    iconAlignment: IconAlignment.end,
                    style: IconButton.styleFrom(
                      iconSize: 35,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
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

String briefScreenDescription({
  required BuildContext context,
  required SimulationWizardScreenType screenType,
}) {
  final translator = translate(context);
  return switch (screenType) {
    SimulationWizardScreenType.mode => translator.gameMode,
    SimulationWizardScreenType.gameVariant => translator.gameVariant,
    SimulationWizardScreenType.startDate => translator.startDate,
    SimulationWizardScreenType.team => translator.team,
    SimulationWizardScreenType.subteam => translator.subteam,
    SimulationWizardScreenType.otherOptions => translator.otherOptions,
  };
}
