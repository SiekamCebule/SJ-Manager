import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/commands/simulation/common/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/training_engine/jumper_training_engine.dart';

class SimulateJumperTrainingCommand {
  SimulateJumperTrainingCommand({
    required this.context,
    required this.database,
    required this.jumper,
    required this.scaleFactor,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Jumper jumper;
  final double scaleFactor;

  void execute() {
    final dynamicParams = database.jumpersDynamicParameters[jumper];
    if (dynamicParams == null) {
      throw StateError(
        'Cannot simulate the training for particular jumper ($jumper) because it does not have dynamic params record in database',
      );
    }
    final changedJumpersDynamicParams = Map.of(database.jumpersDynamicParameters);

    final trainingResult = JumperTrainingEngine(
      jumperSkills: jumper.skills,
      dynamicParams: changedJumpersDynamicParams[jumper]!,
      scaleFactor: scaleFactor,
    ).doTraining();

    changedJumpersDynamicParams[jumper] = changedJumpersDynamicParams[jumper]!.copyWith(
      form: trainingResult.form,
      jumpsConsistency: trainingResult.jumpsConsistency,
      fatigue: trainingResult.fatigue,
    );
    final changedJumpers = List.of(database.jumpers.last);
    changedJumpers[changedJumpers.indexOf(jumper)] =
        jumper.copyWith(skills: trainingResult.skills);
    database.jumpers.set(changedJumpers); // Maybe it doesn't work correctly
    final changedDatabase =
        database.copyWith(jumpersDynamicParameters: changedJumpersDynamicParams);
    context.read<SimulationDatabaseCubit>().update(changedDatabase);
  }
}
