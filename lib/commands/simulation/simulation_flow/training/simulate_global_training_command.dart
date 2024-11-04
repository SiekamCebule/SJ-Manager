import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/simulation/simulation_flow/training/simulate_jumper_training_command.dart';
import 'package:sj_manager/models/simulation/database/helper/simulation_database_helper.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';

class SimulateGlobalTrainingCommand {
  SimulateGlobalTrainingCommand({
    required this.context,
    required this.database,
  });

  final BuildContext context;
  final SimulationDatabase database;

  SimulationDatabase execute() {
    var database = this.database;
    // final jumpers = database.jumpers.last; // TODO
    final jumpers = context.read<SimulationDatabaseHelper>().managerJumpers;
    for (var jumper in jumpers) {
      database = SimulateJumperTrainingCommand(
        context: context,
        database: database,
        jumper: jumper,
      ).execute();
    }
    return database;
  }
}
