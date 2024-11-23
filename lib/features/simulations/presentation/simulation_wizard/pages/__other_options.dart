part of 'simulation_wizard_dialog.dart';

class _OtherOptionsScreen extends StatefulWidget {
  const _OtherOptionsScreen();

  @override
  State<_OtherOptionsScreen> createState() => _OtherOptionsScreenState();
}

class _OtherOptionsScreenState extends State<_OtherOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    final options = context.watch<SimulationWizardOptions>();

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyCheckboxListTileField(
            title: const Text('Archiwizuj wyniki'),
            value: options.archiveEndedSeasonResults,
            onChange: (archiveResults) {
              context.read<SimulationWizardOptions>().archiveEndedSeasonResults =
                  archiveResults;
            },
            onHelpButtonTap: () => showSjmDialog(
              barrierDismissible: true,
              context: context,
              child: const SimpleHelpDialog(
                titleText: 'Archiwizacja wyników',
                contentText:
                    'Archiwizacja polega na zachowaniu wyników z zakończonych już sezonów, przez co można je potem przeglądać. Archiwizacja wymaga dodatkowej pamięci na urządzeniu.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
