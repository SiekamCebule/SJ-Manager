import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulation.dart';
import 'package:sj_manager/utils/colors.dart';

class ChooseSimulationDialog extends StatelessWidget {
  const ChooseSimulationDialog({
    super.key,
    required this.simulations,
    required this.onChoose,
  });

  final List<UserSimulation> simulations;
  final Function(UserSimulation simulation) onChoose;

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
