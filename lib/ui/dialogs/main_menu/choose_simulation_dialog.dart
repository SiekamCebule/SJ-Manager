import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sj_manager/l10n/helpers.dart';
import 'package:sj_manager/models/simulation/flow/simulation_mode.dart';
import 'package:sj_manager/models/simulation/user_simulation/user_simulation.dart';

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

    final content = SizedBox(
      width: bodyWidth,
      height: bodyHeight,
      child: ListView.builder(
        itemCount: simulations.length,
        itemBuilder: (context, index) {
          final simulation = simulations[index];
          return ListTile(
            key: ValueKey(index),
            leading: const SizedBox(), // TODO: Country flag
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

final lastSaveDateTimeFormat = DateFormat('EEE, MMM d, yyyy');

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
