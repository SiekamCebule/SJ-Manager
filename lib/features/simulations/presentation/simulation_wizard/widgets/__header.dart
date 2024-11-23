part of '../pages/simulation_wizard_dialog.dart';

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final navCubit = context.watch<SimulationWizardNavigationCubit>();

    return SizedBox(
      height: 70,
      child: MainMenuCard(
        child: Stack(
          children: [
            Center(
              child: BlocBuilder<SimulationWizardNavigationCubit,
                  SimulationWizardNavigationState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _appropriateTitleText(context, state.screen),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (navCubit.state.screen == SimulationWizardScreenType.gameVariant)
                        HelpIconButton(
                          onPressed: () => showSimpleHelpDialog(
                            context: context,
                            title: 'Warianty gry',
                            content:
                                'Różne warianty gry oferują różne wrażenia - każdy wariant ma inne kalendarze, inne skocznie i zasady rozgrywki. Dzięki temu możesz m.in. symulować legendarne sezony z uwzględnieniem realnych kalendarzy. Chcesz zagrać realistyczną karierę w czasie teraźniejszym, a może karierę opartą na fikcyjnym uniwersum przyszłości?\nWciąż trwają prace nad dodawaniem kolejnych wariantów.',
                          ),
                        )
                    ],
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
