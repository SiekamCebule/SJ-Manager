import 'package:flutter/material.dart';
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
        'Cannot simulate the training for particular jumper ($jumper) because it does not have dynamic params record in database',
      );
    }
    final changedJumpersDynamicParams = Map.of(database.jumperDynamicParams);

    final trainingResult = JumperTrainingEngine(
      jumperSkills: jumper.skills,
      dynamicParams: changedJumpersDynamicParams[jumper]!,
    ).doTraining();

    changedJumpersDynamicParams[jumper] = changedJumpersDynamicParams[jumper]!.copyWith(
      form: trainingResult.form,
      jumpsConsistency: trainingResult.jumpsConsistency,
      fatigue: trainingResult.fatigue,
    );
    final changedJumpers = List.of(database.jumpers.last);

    final newJumper = jumper.copyWith(skills: trainingResult.skills);
    print(database.jumpers.last);
    changedJumpers[database.jumpers.last.indexOf(jumper)] = newJumper;

    print('shold be true once: ${database.jumpers.last.contains(jumper)}');

    database.idsRepo.update(id: database.idsRepo.idOf(jumper), newItem: newJumper);
    database.jumpers.set(changedJumpers); // Maybe it doesn't work correctly
    final changedDatabase =
        database.copyWith(jumperDynamicParams: changedJumpersDynamicParams);
    return changedDatabase;
  }
}
