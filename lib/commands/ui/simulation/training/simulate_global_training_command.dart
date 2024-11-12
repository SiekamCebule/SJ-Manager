import 'package:flutter/material.dart';
import 'package:sj_manager/commands/ui/simulation/training/simulate_jumper_training_command.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';

class SimulateGlobalTrainingCommand {
  SimulateGlobalTrainingCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  void execute() {
    var database = this.database;
    final jumpers = database.jumpers;
    print('SimulateGlobalTrainingCommand, jumpers: $jumpers');
    for (var jumper in jumpers) {
      SimulateJumperTrainingCommand(
        context: context,
        database: database,
        jumper: jumper,
      ).execute();
    }
  }
}
