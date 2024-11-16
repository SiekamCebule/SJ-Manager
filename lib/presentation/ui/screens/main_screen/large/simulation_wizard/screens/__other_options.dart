part of '../simulation_wizard_dialog.dart';

class _OtherOptionsScreen extends StatefulWidget {
  const _OtherOptionsScreen();

  @override
  State<_OtherOptionsScreen> createState() => _OtherOptionsScreenState();
}

class _OtherOptionsScreenState extends State<_OtherOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: context
                .read<SimulationWizardOptionsRepo>()
                .archiveEndedSeasonResults
                .items,
            builder: (context, snapshot) {
              return MyCheckboxListTileField(
                title: const Text('Archiwizuj wyniki'),
                value: snapshot.data ?? true,
                onChange: (archiveResults) {
                  context
                      .read<SimulationWizardOptionsRepo>()
                      .archiveEndedSeasonResults
                      .set(archiveResults);
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
              );
            },
          ),
        ],
      ),
    );
  }
}
