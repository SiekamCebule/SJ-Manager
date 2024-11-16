import 'package:flutter/material.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/data/models/simulation/user_simulation/user_simulation_model.dart';

class DeleteSimulationAreYouSureDialog extends StatelessWidget {
  const DeleteSimulationAreYouSureDialog({
    super.key,
    required this.simulation,
  });

  final UserSimulationModel simulation;

  @override
  Widget build(BuildContext context) {
    final regularContentStyle = Theme.of(context).textTheme.bodyMedium;
    final boldContentStyle = regularContentStyle!.copyWith(fontWeight: FontWeight.w600);
    return AlertDialog(
      title: const Text('Usunąć symulację?'),
      content: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Czy na pewno chcesz usunąć symulację ',
              style: regularContentStyle,
            ),
            TextSpan(
              text: simulation.name,
              style: boldContentStyle,
            ),
            TextSpan(
              text: '?',
              style: regularContentStyle,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(translate(context).no),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(translate(context).yes),
        ),
      ],
    );
  }
}
