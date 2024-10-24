import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/utils/random/random.dart';

class SimulateJumperTrainingCommand {
  SimulateJumperTrainingCommand({
    required this.context,
    required this.database,
    required this.jumper,
    required this.scale,
  });

  final BuildContext context;
  final SimulationDatabase database;
  final Jumper jumper;
  final double scale;

  void execute() {
    final dynamicParams = database.jumpersDynamicParameters[jumper];
    if (dynamicParams == null) {
      throw StateError(
        'Cannot simulate the training for particular jumper ($jumper) because it does not have dynamic params record in database',
      );
    }
    final trainingResult = JumperTrainingSimulator(
            jumper: jumper, dynamicParams: dynamicParams, scale: scale)
        .simulateTraining();
    final changedJumpersDynamicParams = Map.of(database.jumpersDynamicParameters);
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
  late double _developmentPotentialFactor;
  late double _takeoffQuality;
  late double _flightQuality;
  late double _landingQuality;
  late double _form;

  JumperTrainingResult simulateTraining() {
    if (dynamicParams.trainingConfig == null) {
      throw ArgumentError(
        'Jumper\'s ($jumper) training config is null so cannot simulate the training',
      );
    }

    _trainingConfig = dynamicParams.trainingConfig!;
    // TODO: Injuries
    _setDevelopmentPotentialFactor();
    _simulateTakeoffTraining();
    _simulateFlightTraining();
    _simulateLandingTraining();
    _simulateFormTraining();

    final newSkills = jumper.skills.copyWith(
      takeoffQuality: _takeoffQuality,
      flightQuality: _flightQuality,
      landingQuality: _landingQuality,
    ); // TODO
    return JumperTrainingResult(
      skills: newSkills,
      form: _form,
      jumpsConsistency: jumpsConsistency,
      fatigue: fatigue,
    );
  }

  void _setDevelopmentPotentialFactor() {
    final fromMorale = dynamicParams.morale < 0.2 ? dynamicParams.morale * (70 / 100) : 0;
    final fromFatigue =
        -dynamicParams.fatigue * (30 / 100); // TODO: Dopasować jeszcze te mnożniki

    // Bardzo ważny współczynnik potencjału rozwoju. Tworzony deklaratywnie
    _developmentPotentialFactor = 0.5 + (fromMorale + fromFatigue) / 4;
  }

  void _simulateTakeoffTraining() {
    _takeoffQuality = jumper.skills.takeoffQuality;

    const takeoffDivider = 100.0;
    const developmentPotentialMultiplier = 1.0;
    const trainingEffeciencyMultiplier = 1.0;

    final takeoffPoints = _trainingConfig.points[JumperTrainingPointsCategory.takeoff]!;

    var takeoffDelta = -0.05;
    takeoffDelta += (takeoffPoints *
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
        (dynamicParams.trainingEffeciencyFactor * trainingEffeciencyMultiplier));
    takeoffDelta /= takeoffDivider;
    const maxRandomOnOneSide = 0.03;
    final takeoffRandom = linearRandomDouble(-maxRandomOnOneSide, maxRandomOnOneSide);
    takeoffDelta += (takeoffRandom);
    takeoffDelta *= scale;

    _takeoffQuality += takeoffDelta;
  }

  void _simulateFlightTraining() {
    _flightQuality = jumper.skills.flightQuality;

    const flightDivider = 100.0;
    const developmentPotentialMultiplier = 1.0;
    const trainingEffeciencyMultiplier = 1.0;

    final flightPoints = _trainingConfig.points[JumperTrainingPointsCategory.flight]!;

    var flightDelta = -0.05;
    flightDelta += (flightPoints *
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
        (dynamicParams.trainingEffeciencyFactor * trainingEffeciencyMultiplier));
    flightDelta /= flightDivider;
    const maxRandomOnOneSide = 0.03;
    final flightRandom = linearRandomDouble(-maxRandomOnOneSide, maxRandomOnOneSide);
    flightDelta += (flightRandom);
    flightDelta *= scale;

    _flightQuality += flightDelta;
  }

  void _simulateLandingTraining() {
    _landingQuality = jumper.skills.landingQuality;

    const landingDivider = 100.0; // 100.0 dla 0.1
    const developmentPotentialMultiplier = 1.0;
    const trainingEffeciencyMultiplier = 1.0;

    final flightPoints = _trainingConfig.points[JumperTrainingPointsCategory.landing]!;

    var landingDelta = -0.05;
    landingDelta += (flightPoints *
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
        (dynamicParams.trainingEffeciencyFactor * trainingEffeciencyMultiplier));
    landingDelta /= landingDivider;
    const maxRandomOnOneSide = 0.03;
    final landingRandom = linearRandomDouble(-maxRandomOnOneSide, maxRandomOnOneSide);
    landingDelta += (landingRandom);
    landingDelta *= scale;

    _flightQuality += landingDelta;
  }

  void _simulateFormTraining() {
    // TODO
    _form = 0;
  }
}

class JumperTrainingResult {
  const JumperTrainingResult({
    required this.skills,
    required this.form,
    required this.jumpsConsistency,
    required this.fatigue,
  });

  final JumperSkills skills;
  final double form;
  final double jumpsConsistency;
  final double fatigue;
}
