import 'package:flutter/material.dart';
import 'package:sj_manager/general_ui/reusable_widgets/sjm_dialog_ok_pop_button.dart';

class TrainingTutorialDialog extends StatelessWidget {
  const TrainingTutorialDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;

    return AlertDialog(
      title: const Text('Jak przeprowadzać trening?'),
      content: Text(
        '''Aby efektywnie przeprowadzić trening, musimy dostosowywać plan treningowy do potrzeb zawodnika. Często na początku przygotowań nie chcemy jeszcze pracować stricte nad formą, ale nad aspektami technicznymi czy równością skoków. Dobrym podejściem NIE jest trzymanie się przez cały sezon tej samej konfiguracji. Jeśli chcemy przygotować formę na konkretny moment sezonu, możemy zwiększać trening atrybutu "Forma" dopiero jakiś czas przed zamierzonym "wystrzałem", np. chwilę przed mistrzostwami. Należy pamiętać o tym, że mocne skupienie się na formie może spowodować późniejszy kryzys.  
        ''',
        style: textStyle,
      ),
      actions: const [
        SjmDialogOkPopButton(),
      ],
    );
  }
}
