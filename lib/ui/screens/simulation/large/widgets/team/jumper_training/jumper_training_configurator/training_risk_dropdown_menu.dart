import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation/flow/training/training_risk.dart';
import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/dialogs/simple_help_dialog.dart';

class TrainingRiskDropdownMenu extends StatelessWidget {
  const TrainingRiskDropdownMenu({
    super.key,
    this.initial,
    required this.onChange,
  });

  final TrainingRisk? initial;
  final Function(TrainingRisk value) onChange;

  @override
  Widget build(BuildContext context) {
    return MyDropdownField(
      label: const Text('Trening'),
      initial: initial,
      onChange: (value) => onChange(value!),
      entries: const [
        DropdownMenuEntry(
          value: TrainingRisk.verySafe,
          label: 'Bardzo bezpieczny',
        ),
        DropdownMenuEntry(
          value: TrainingRisk.safe,
          label: 'Bezpieczny',
        ),
        DropdownMenuEntry(
          value: TrainingRisk.balanced,
          label: 'Wyważony',
        ),
        DropdownMenuEntry(
          value: TrainingRisk.risky,
          label: 'Ryzykowny',
        ),
        DropdownMenuEntry(
          value: TrainingRisk.veryRisky,
          label: 'Bardzo ryzykowny',
        ),
      ],
      onHelpButtonTap: () async {
        await showSimpleHelpDialog(
          context: context,
          title: 'Ryzyko treningu',
          content:
              'Ryzykowny trening może dać spektakularny sukces, ale może też spowodować kryzys. Bezpieczny trening raczej się uda, ale nie zawsze będą dzięki niemu fajerwerki. Używaj tej opcji rozsądnie!',
        );
      },
    );
  }
}
