import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation/flow/training/jumping_technique_change_training.dart';

import 'package:sj_manager/ui/database_item_editors/fields/my_dropdown_field.dart';
import 'package:sj_manager/ui/dialogs/simple_help_dialog.dart';

class JumpingTechniqueChangeTrainingDropdown extends StatelessWidget {
  const JumpingTechniqueChangeTrainingDropdown({
    super.key,
    this.width,
    this.initial,
    required this.onChange,
  });

  final double? width;
  final JumpingTechniqueChangeTrainingType? initial;
  final Function(JumpingTechniqueChangeTrainingType value) onChange;

  @override
  Widget build(BuildContext context) {
    return MyDropdownField(
      label: const Text('Ryzyko w skokach'),
      initial: initial,
      width: width,
      onChange: (value) => onChange(value!),
      entries: const [
        DropdownMenuEntry(
          value: JumpingTechniqueChangeTrainingType.decreaseRisk,
          label: 'Zmniejsz',
        ),
        DropdownMenuEntry(
          value: JumpingTechniqueChangeTrainingType.maintain,
          label: 'Utrzymaj',
        ),
        DropdownMenuEntry(
          value: JumpingTechniqueChangeTrainingType.increaseRisk,
          label: 'Zwiększ',
        ),
      ],
      onHelpButtonTap: () async {
        await showSimpleHelpDialog(
          context: context,
          title: 'Ryzyko w skokach',
          content:
              'Możesz nauczyć zawodnika/zawodniczkę skakać bardziej lub mniej ryzykownie. Taka zmiana może zająć trochę czasu.',
        );
      },
    );
  }
}
