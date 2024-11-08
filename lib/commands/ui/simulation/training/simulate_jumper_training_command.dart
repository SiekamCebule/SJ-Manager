import 'package:flutter/material.dart';
import 'package:sj_manager/commands/simulation_database/simulation_database_commander.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/algorithms/training_engine/jumper_training_engine.dart';

class SimulateJumperTrainingCommand {
  SimulateJumperTrainingCommand({
    required this.context,
    required this.database,
    required this.jumper,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Jumper jumper;

  SimulationDatabase execute() {
    final dynamicParams = database.jumperDynamicParams[jumper];
    if (dynamicParams == null) {
      throw StateError(
        'Cannot simulate the training for particular jumper ($jumper) because it doesn\'t have JumperDynamicParams record in database',
      );
    }
    final trainingResult = JumperTrainingEngine(
      jumperSkills: jumper.skills,
      dynamicParams: database.jumperDynamicParams[jumper]!,
    ).doTraining();

    return SimulationDatabaseCommander(database: database).registerJumperTraining(
      jumper: jumper,
      result: trainingResult,
      date: database.currentDate,
    );
  }
}
