part of '../simulation_wizard_dialog.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: MainMenuCard(
        child: Stack(
          children: [
            Center(
              child: BlocBuilder<SimulationWizardNavigationCubit,
                  SimulationWizardNavigationState>(
                builder: (context, state) {
                  return Text(
                    _appropriateTitleText(context, state.screen),
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  icon: const Icon(Symbols.close),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _appropriateTitleText(BuildContext context, SimulationWizardScreenType screen) {
    return switch (screen) {
      SimulationWizardScreenType.mode => "Wybierz tryb rozgrywki",
      SimulationWizardScreenType.startDate => "Wybierz datę startową",
      SimulationWizardScreenType.gameVariant => "Wybierz wariant rozgrywki",
      SimulationWizardScreenType.team => "Wybierz swój kraj",
      SimulationWizardScreenType.subteam => "Wybierz swoją poddrużynę (kadrę)",
      SimulationWizardScreenType.otherOptions => "Przyjrzyj się innym opcjom",
    };
  }
}
