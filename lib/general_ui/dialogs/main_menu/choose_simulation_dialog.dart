import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/sjm_simulation.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_mode.dart';
import 'package:sj_manager/general_ui/dialogs/main_menu/delete_simulation_are_you_sure_dialog.dart';
import 'package:sj_manager/core/general_utils/colors.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';

class ChooseSimulationDialog extends StatelessWidget {
  const ChooseSimulationDialog({
    super.key,
    required this.simulations,
    required this.onChoose,
    required this.onDelete,
  });

  final List<SjmSimulation> simulations;
  final Function(SjmSimulation simulation) onChoose;
  final Function(SjmSimulation simulation) onDelete;

  @override
  Widget build(BuildContext context) {
    const double bodyWidth = 400;
    const double bodyHeight = 300;
    final brightness = Theme.of(context).brightness;
    final tileColor =
        Theme.of(context).colorScheme.surfaceContainer.blendWithBg(brightness, -0.01);

    final content = SizedBox(
      width: bodyWidth,
      height: bodyHeight,
      child: ListView.builder(
        itemCount: simulations.length,
        itemBuilder: (context, index) {
          final simulation = simulations[index];
          return ListTile(
            tileColor: tileColor,
            splashColor: tileColor.blendWithBg(brightness, -0.015),
            hoverColor: tileColor.blendWithBg(brightness, -0.015),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            key: ValueKey(index),
            leading: const SizedBox(),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showSjmDialog(
                  context: context,
                  child: DeleteSimulationAreYouSureDialog(
                    simulation: simulation,
                  ),
                );
                if (shouldDelete) {
                  onDelete(simulation);
                }
              },
              icon: const Icon(Symbols.delete),
            ),
            title: Text(simulation.name),
            subtitle: SizedBox(
              width: 120,
              child: Row(
                children: [
                  Text(simulationModeName(
                    context: context,
                    mode: simulation.mode,
                  )),
                  const Gap(20),
                  Text(lastSaveDateTimeFormat.format(simulation.saveTime)),
                ],
              ),
            ),
            onTap: () {
              onChoose(simulation);
            },
          );
        },
      ),
    );

    return AlertDialog(
      title: const Text('Wybierz symulację'),
      content: content,
    );
  }
}

final lastSaveDateTimeFormat = DateFormat("MMM d, yyyy (HH:mm)");

String simulationModeName({
  required BuildContext context,
  required SimulationMode mode,
}) {
  final translator = translate(context);
  return switch (mode) {
    SimulationMode.classicCoach => translator.classicCoach,
    SimulationMode.personalCoach => translator.personalCoach,
    SimulationMode.observer => translator.observer,
  };
}
