import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';

class SimulateJumperTrainingCommand {
  SimulateJumperTrainingCommand({
    required this.context,
    required this.database,
    required this.jumper,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Jumper jumper;

  void execute() {
    final dynamicParams = database.jumpersDynamicParameters[jumper];
    if (dynamicParams == null) {
      throw StateError(
        'Cannot simulate the training for particular jumper ($jumper) because it does not have dynamic params record in database',
      );
    }
    final newDynamicParams =
        JumperTrainingSimulator(jumper: jumper, dynamicParams: dynamicParams)
            .simulateTraining();
    final changedJumpersDynamicParams = Map.of(database.jumpersDynamicParameters);
    changedJumpersDynamicParams[jumper] = newDynamicParams;
    final changedDatabase =
        database.copyWith(jumpersDynamicParameters: changedJumpersDynamicParams);
    context.read<SimulationDatabaseCubit>().update(changedDatabase);
  }
}

class JumperTrainingSimulator {
  JumperTrainingSimulator({
    required this.jumper,
    required this.dynamicParams,
    required this.scale,
  });

  final Jumper jumper;
  final JumperDynamicParams dynamicParams;
  final double
      scale; // 1.0 to typowy trening. 0.5 to połowiczny trening (połowiczne wyniki, ryzyka..)

  late JumperTrainingConfig _trainingConfig;
  late double _trainingFactor;
  late double _takeoffSkill;

  JumperTrainingResult simulateTraining() {
    if (dynamicParams.trainingConfig == null) {
      throw ArgumentError(
        'Jumper\'s ($jumper) training config is null so cannot simulate the training',
      );
    }

    _trainingConfig = dynamicParams.trainingConfig!;
    // TODO: Injuries
    _setTrainingFactor();
    _simulateTakeoffTraining();

    final newSkills = jumper.skills.copyWith(); // TODO
    return JumperTrainingResult(
      skills: newSkills,
      form: form,
      jumpsConsistency: jumpsConsistency,
    );
  }

  void _setTrainingFactor() {
    _trainingFactor =
        1.0; // Bardzo ważna zmienna definiująca efektywność treningu zawodnika
  }

  void _simulateTakeoffTraining() {
    _takeoffSkill = jumper.skills.takeoffQuality;

    // Zmienna regulująca jak bardzo duże zmiany zachodzą w treningu wybicia
    const takeoffDivider = 1.0;
    final takeoffPoints = _trainingConfig.points[JumperTrainingPointsCategory.takeoff]!;

    var takeoffDelta = (takeoffPoints * _trainingFactor) / takeoffDivider;
    final takeoffRandom = Random().nextInt(100); // TODO
    takeoffDelta += takeoffRandom;

    _takeoffSkill += takeoffDelta;
  }
}

class JumperTrainingResult {
  const JumperTrainingResult({
    required this.skills,
    required this.form,
    required this.jumpsConsistency,
  });

  final JumperSkills skills;
  final double form;
  final double jumpsConsistency;
}
