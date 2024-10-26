import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sj_manager/bloc/simulation/simulation_database_cubit.dart';
import 'package:sj_manager/models/simulation/database/simulation_database_and_models/simulation_database.dart';
import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/simulation/flow/training/jumping_technique_change_training.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/models/user_db/jumper/jumping_technique.dart';
import 'package:sj_manager/utils/random/random.dart';

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
    changedJumpersDynamicParams[jumper] = changedJumpersDynamicParams[jumper]!.copyWith(
      jumpingTechniqueChangeTrainingDaysLeft:
          (dynamicParams.jumpingTechniqueChangeTrainingDaysLeft ?? 0) - 1,
    );

    final trainingResult = JumperTrainingSimulator(
      jumper: jumper,
      dynamicParams: changedJumpersDynamicParams[jumper]!,
      scaleFactor: scaleFactor,
    ).simulateTraining();

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
    required this.scaleFactor,
  });

  final Jumper jumper;
  final JumperDynamicParams dynamicParams;
  final double scaleFactor;

  late JumperTrainingConfig _trainingConfig;
  late double _developmentPotentialFactor;
  late double _takeoffQuality;
  late double _flightQuality;
  late double _landingQuality;
  late double _form;
  late double _formDelta;
  late double _formStability;
  late double _jumpsConsistency;
  late JumpingTechnique _jumpingTechnique;
  late double _fatigue;

  JumperTrainingResult simulateTraining() {
    _setUp();
    _calculateDevelopmentPotentialFactor();
    _simulateTakeoffTraining();
    _simulateFlightTraining();
    _simulateLandingTraining();
    _simulateFormTraining();
    _simulateFormStabilityChange();
    _simulateJumpsConsistencyTraining();
    _simulateJumpingTechniqueChange();
    _simulateFatigue();
    _simulateInjuries();

    final newSkills = jumper.skills.copyWith(
      takeoffQuality: _takeoffQuality,
      flightQuality: _flightQuality,
      landingQuality: _landingQuality,
    );
    return JumperTrainingResult(
      skills: newSkills,
      form: _form,
      formStability: _formStability,
      jumpsConsistency: _jumpsConsistency,
      fatigue: _fatigue,
    );
  }

  void _setUp() {
    if (dynamicParams.trainingConfig == null) {
      throw ArgumentError(
        'Jumper\'s ($jumper) training config is null so cannot simulate the training',
      );
    }
    _trainingConfig = dynamicParams.trainingConfig!;
  }

  void _calculateDevelopmentPotentialFactor() {
    final fromMorale = dynamicParams.morale < 0.2 ? dynamicParams.morale * (40 / 100) : 0;
    final fromFatigue = -dynamicParams.fatigue * (60 / 100);

    _developmentPotentialFactor = 0.5 + (fromMorale + fromFatigue) / 4;
  }

  void _simulateTakeoffTraining() {
    _takeoffQuality = jumper.skills.takeoffQuality;

    const developmentPotentialMultiplier = 1.0;
    const trainingEfficiencyMultiplier = 1.0;

    final points = _trainingConfig.points[JumperTrainingPointsCategory.takeoff]!;

    const potentialRandomForOnePoint = 0.15;

    final negativeRandom = linearRandomDouble(0, potentialRandomForOnePoint * 5);
    final positiveRandomMax =
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
            (dynamicParams.trainingEfficiencyFactor * trainingEfficiencyMultiplier) *
            (potentialRandomForOnePoint * points);

    final positiveRandom = linearRandomDouble(0, positiveRandomMax);
    final random = (negativeRandom + positiveRandom) * scaleFactor;

    _takeoffQuality += random;
  }

  void _simulateFlightTraining() {
    _flightQuality = jumper.skills.flightQuality;

    const developmentPotentialMultiplier = 1.0;
    const trainingEfficiencyMultiplier = 1.0;

    final points = _trainingConfig.points[JumperTrainingPointsCategory.flight]!;

    const potentialRandomForOnePoint = 0.15;

    final negativeRandom = linearRandomDouble(0, potentialRandomForOnePoint * 5);
    final positiveRandomMax =
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
            (dynamicParams.trainingEfficiencyFactor * trainingEfficiencyMultiplier) *
            (potentialRandomForOnePoint * points);

    final positiveRandom = linearRandomDouble(0, positiveRandomMax);
    final random = (negativeRandom + positiveRandom) * scaleFactor;

    _flightQuality += random;
  }

  void _simulateLandingTraining() {
    _landingQuality = jumper.skills.landingQuality;

    const developmentPotentialMultiplier = 1.0;
    const trainingEfficiencyMultiplier = 1.0;

    final points = _trainingConfig.points[JumperTrainingPointsCategory.landing]!;

    const potentialRandomForOnePoint = 0.15;

    final negativeRandom = linearRandomDouble(0, potentialRandomForOnePoint * 5);
    final positiveRandomMax =
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
            (dynamicParams.trainingEfficiencyFactor * trainingEfficiencyMultiplier) *
            (potentialRandomForOnePoint * points);

    final positiveRandom = linearRandomDouble(0, positiveRandomMax);
    final random = (negativeRandom + positiveRandom) * scaleFactor;

    _landingQuality += random;
  }

  void _simulateFormTraining() {
    _form = dynamicParams.form;

    const developmentPotentialMultiplier = 1.0;
    const trainingEfficiencyMultiplier = 1.0;

    final formPoints = _trainingConfig.points[JumperTrainingPointsCategory.form]!;

    const potentialRandomForOnePoint = 0.15;

    final negativeRandomMax =
        potentialRandomForOnePoint * 5 * (1.0 - dynamicParams.formStability);
    final negativeRandom = linearRandomDouble(0, negativeRandomMax);

    final positiveRandomMax =
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
            (dynamicParams.trainingEfficiencyFactor * trainingEfficiencyMultiplier) *
            (potentialRandomForOnePoint * formPoints) *
            (1.0 / _form);

    final positiveRandom = linearRandomDouble(0, positiveRandomMax);
    final random = (negativeRandom + positiveRandom) * scaleFactor;

    _formDelta = random;
    _form += random;
  }

  void _simulateFormStabilityChange() {
    _formStability = dynamicParams.formStability;

    final delta = 0.05 - (_formDelta / 1);

    _formStability += delta;
  }

  void _simulateJumpsConsistencyTraining() {
    _jumpsConsistency = dynamicParams.jumpsConsistency;

    const developmentPotentialMultiplier = 1.0;
    const trainingEfficiencyMultiplier = 1.0;

    _trainingConfig.balance;
    const potentialRandomForMaxChange = 0.1;

    final negativeRandomMax = (_trainingConfig.balance * 0.5);
    final negativeRandom = linearRandomDouble(0, negativeRandomMax);

    final positiveRandomMax =
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
            (dynamicParams.trainingEfficiencyFactor * trainingEfficiencyMultiplier) *
            (potentialRandomForMaxChange * _trainingConfig.balance);
    final positiveRandom = linearRandomDouble(0, positiveRandomMax);

    final random = (negativeRandom + positiveRandom) * scaleFactor;

    _jumpsConsistency += random;
  }

  void _simulateJumpingTechniqueChange() {
    _jumpingTechnique = jumper.skills.jumpingTechnique;

    final jumpingTechniqueChangeIsEnded = true; // TODO
    if (jumpingTechniqueChangeIsEnded) {
      final shouldIncrease = _trainingConfig.jumpingTechniqueChangeTraining ==
          JumpingTechniqueChangeTrainingType.increaseRisk;
      final shouldDecrease = _trainingConfig.jumpingTechniqueChangeTraining ==
          JumpingTechniqueChangeTrainingType.decreaseRisk;
      if (shouldIncrease) {
        _jumpingTechnique = getMoreRiskyJumpingTechnique(_jumpingTechnique);
      } else if (shouldDecrease) {
        _jumpingTechnique = getLessRiskyJumpingTechnique(_jumpingTechnique);
      }
    }
  }

  void _simulateFatigue() {
    _fatigue = 0;

    const onePointEffectDivider = 100;
    const fatigueBaseDelta = -0.5;

    const takeoffDivider = 8.0;
    const flightDivider = 8.0;
    const landingDivider = 30.0;
    const formDivider = 1.0;

    final takeoffPoints = _trainingConfig.points[JumperTrainingPointsCategory.takeoff]!;
    final flightPoints = _trainingConfig.points[JumperTrainingPointsCategory.flight]!;
    final landingPoints = _trainingConfig.points[JumperTrainingPointsCategory.landing]!;
    final formPoints = _trainingConfig.points[JumperTrainingPointsCategory.form]!;

    final fatigueDelta = fatigueBaseDelta +
        (takeoffPoints / takeoffDivider / onePointEffectDivider) +
        (flightPoints / flightDivider / onePointEffectDivider) +
        (landingPoints / landingDivider / onePointEffectDivider) +
        (formPoints / formDivider / onePointEffectDivider);

    _fatigue += fatigueDelta;
  }

  void _simulateInjuries() {
    // TODO
  }
}

class JumperTrainingResult {
  const JumperTrainingResult({
    required this.skills,
    required this.form,
    required this.formStability,
    required this.jumpsConsistency,
    required this.fatigue,
  });

  final JumperSkills skills;
  final double form;
  final double formStability;
  final double jumpsConsistency;
  final double fatigue;
}
