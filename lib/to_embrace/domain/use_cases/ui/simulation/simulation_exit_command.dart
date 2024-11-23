import 'package:flutter/material.dart';
import 'package:sj_manager/main.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/simulation_database.dart';
import 'package:sj_manager/to_embrace/ui/screens/simulation/large/dialogs/simulation_exit_are_you_sure_dialog.dart';
import 'package:sj_manager/core/general_utils/dialogs.dart';

class SimulationExitCommand {
  SimulationExitCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  Future<void> execute() async {
    final bool? saveChanges = await showSjmDialog(
      barrierDismissible: true,
      context: context,
      child: const SimulationExitAreYouSureDialog(),
    );
    if (saveChanges == false) {
      _exitWithoutSaving();
    } else if (saveChanges == true) {
      if (!context.mounted) return;
      _exitSimulationWithSaving();
    }
  }

  void _exitSimulationWithSaving() async {
    //await context.read<SimulationCubit>().preserve(); TODO

    if (!context.mounted) return;
    _cleanUpAndPop();
  }

  void _exitWithoutSaving() {
    _cleanUpAndPop();
  }

  void _cleanUpAndPop() {
    router.pop(context);
  }
}
