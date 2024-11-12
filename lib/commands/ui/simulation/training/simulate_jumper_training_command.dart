import 'package:flutter/material.dart';
import 'package:sj_manager/commands/simulation_database/simulation_database_commander.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/algorithms/training_engine/jumper_training_engine.dart';
import 'package:sj_manager/models/simulation/jumper/simulation_jumper.dart';

class SimulateJumperTrainingCommand {
  SimulateJumperTrainingCommand({
    required this.context,
    required this.database,
    required this.jumper,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final SimulationJumper jumper;

  void execute() {
    if (jumper.trainingConfig == null) {
      throw StateError(
        'Cannot simulate the training for particular jumper ($jumper) because it did not get the training configurated',
      );
    }
    final trainingResult = JumperTrainingEngine(
      jumper: jumper,
    ).doTraining();

    SimulationDatabaseCommander(database: database).registerJumperTraining(
      jumper: jumper,
      result: trainingResult,
      date: database.currentDate,
    );
  }
}
