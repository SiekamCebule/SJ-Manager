import 'package:flutter/material.dart';
import 'package:sj_manager/general_ui/reusable_widgets/sjm_dialog_ok_pop_button.dart';

class FeatureNotAvailableDialog extends StatelessWidget {
  const FeatureNotAvailableDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Funkcja niedostępna'),
      content: Text('Jeszcze pracujemy nad tą funkcją...'),
      actions: [
        SjmDialogOkPopButton(),
      ],
    );
  }
}
