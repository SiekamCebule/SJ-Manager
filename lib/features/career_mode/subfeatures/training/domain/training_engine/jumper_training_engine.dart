import 'dart:math';

import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/training_engine/jumper_training_engine_settings.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_result.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/core/general_utils/random/random.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/training_utils.dart';

class JumperTrainingEngine {
  JumperTrainingEngine({
    this.settings = sjmDefaultTrainingEngineSettings,
    required this.jumper,
  });

  final JumperTrainingEngineSettings settings;
  final SimulationJumper jumper;

  late JumperTrainingConfig _trainingConfig;
  late double _developmentPotentialFactor;
  late JumperTrainingResult _result;

  JumperTrainingResult doTraining() {
    _setUp();
    _calculateDevelopmentPotentialFactor();
    _createResultObject();
    simulateInjuries();
    return _result;
  }

  void _setUp() {
    if (jumper.trainingConfig == null) {
      throw ArgumentError(
        'Jumper\'s (${jumper.nameAndSurname()}) training config is null so cannot simulate the training',
      );
    }
    _trainingConfig = jumper.trainingConfig!;
  }

  void _calculateDevelopmentPotentialFactor() {
    final fromMorale = jumper.morale < settings.moraleFactorThreshold
        ? jumper.morale * settings.moraleFactorMultiplier
        : 0;
    final fromFatigue = -jumper.fatigue * settings.fatigueFactorMultiplier;

    _developmentPotentialFactor = settings.developmentPotentialFactorBase +
        ((fromMorale + fromFatigue) / settings.developmentPotentialDivider);
  }

  void _createResultObject() {
    _result = JumperTrainingResult(
      takeoffDelta: jumper.takeoffQuality + _computeTakeoffDelta(),
      flightDelta: jumper.flightQuality + _computeFlightDelta(),
      landingDelta: jumper.landingQuality + _computeLandingDelta(),
      formDelta: jumper.form + _computeFormDelta(),
      consistencyDelta: jumper.jumpsConsistency + _computeConsistencyDelta(),
      fatigueDelta: jumper.fatigue + _computeFatigueDelta(),
    );
  }

  double _computeTakeoffDelta() {
    final balance = _trainingConfig.balance[JumperTrainingCategory.takeoff]!;
    const mean = 0.0;
    final scale = settings.takeoffRandomScaleBase +
        (balance / settings.takeoffRandomScaleBalanceDivider);
    final random = dampedCauchyDistributionRandom(
      mean,
      scale,
      settings.takeoffRandomCauchyDampingFactor,
    );

    final distanceFromCenter = (jumper.takeoffQuality - 10).abs();
    var delta = random / settings.takeoffBalanceEffectDivider;
    final directionalMultiplier = (jumper.takeoffQuality - 10) *
        delta.sign /
        settings.takeoffDirectionalMultiplierDivider;
    final exponentiationBase = 1 +
        (distanceFromCenter / settings.takeoffDeltaDampingBaseDivider) *
            (1 + directionalMultiplier);
    final dampingDivider = pow(exponentiationBase, settings.takeoffDeltaDampingExponent);
    delta /= dampingDivider;

    return delta;
  }

  double _computeFlightDelta() {
    final balance = _trainingConfig.balance[JumperTrainingCategory.flight]!;
    const mean = 0.0;
    final scale = settings.flightRandomScaleBase +
        (balance / settings.flightRandomScaleBalanceDivider);
    final random = dampedCauchyDistributionRandom(
      mean,
      scale,
      settings.flightRandomCauchyDampingFactor,
    );

    final distanceFromCenter = (jumper.flightQuality - 10).abs();
    var delta = random / settings.flightBalanceEffectDivider;
    final directionalMultiplier = (jumper.flightQuality - 10) *
        delta.sign /
        settings.flightDirectionalMultiplierDivider;
    final exponentiationBase = 1 +
        (distanceFromCenter / settings.flightDeltaDampingBaseDivider) *
            (1 + directionalMultiplier);
    final dampingDivider = pow(exponentiationBase, settings.flightDeltaDampingExponent);
    delta /= dampingDivider;

    return delta;
  }

  double _computeLandingDelta() {
    final balance = _trainingConfig.balance[JumperTrainingCategory.landing]!;
    const mean = 0.0;
    final scale = settings.landingRandomScaleBase +
        (balance / settings.landingRandomScaleBalanceDivider);
    final random = dampedCauchyDistributionRandom(
      mean,
      scale,
      settings.landingRandomCauchyDampingFactor,
    );

    final distanceFromCenter = (jumper.landingQuality - 10).abs();
    var delta = random / settings.landingBalanceEffectDivider;
    final directionalMultiplier = (jumper.landingQuality - 10) *
        delta.sign /
        settings.landingDirectionalMultiplierDivider;
    final exponentiationBase = 1 +
        (distanceFromCenter / settings.landingDeltaDampingBaseDivider) *
            (1 + directionalMultiplier);
    final dampingDivider = pow(exponentiationBase, settings.landingDeltaDampingExponent);
    delta /= dampingDivider;

    return delta;
  }

  double _computeFormDelta() {
    final balance = _trainingConfig.balance[JumperTrainingCategory.form]!;
    const mean = 0.0;
    final scale =
        settings.formRandomScaleBase + (balance / settings.formRandomScaleBalanceDivider);
    final random = dampedCauchyDistributionRandom(
      mean,
      scale,
      settings.formRandomCauchyDampingFactor,
    );

    // Tłumienie delty
    final distanceFromCenter = (jumper.form - 10).abs();
    var delta = random / settings.formBalanceDivider;
    final directionalMultiplier =
        (jumper.form - 10) * delta.sign / settings.formDirectionalMultiplierDivider;
    final exponentiationBase = 1 +
        (distanceFromCenter / settings.formDeltaDampingBaseDivider) *
            (1 + directionalMultiplier);
    final dampingDivider = pow(exponentiationBase, settings.formDeltaDampingExponent);

    delta /= dampingDivider;

    return delta;
  }

  double _computeConsistencyDelta() {
    final avgBalance = sjmCalculateAvgTrainingBalance(_trainingConfig.balance);
    final mean = -avgBalance / settings.consistencyMeanAvgBalanceDivider;
    final scale = settings.consistencyRandomScaleBase;
    final random = dampedCauchyDistributionRandom(
      mean,
      scale,
      settings.consistencyRandomCauchyDampingFactor,
    );
    // Tłumienie delty
    final distanceFromCenter = (jumper.jumpsConsistency - 10).abs();
    var delta = random / settings.consistencyBalanceDivider;
    final directionalMultiplier = (jumper.jumpsConsistency - 10) *
        delta.sign /
        settings.consistencyDirectionalMultiplierDivider;
    final exponentiationBase = 1 +
        (distanceFromCenter / settings.consistencyDeltaDampingBaseDivider) *
            (1 + directionalMultiplier);
    final dampingDivider =
        pow(exponentiationBase, settings.consistencyDeltaDampingExponent);

    delta /= dampingDivider;

    return delta;
  }

  double _computeFatigueDelta() {
    return 0;
  }

  void simulateInjuries() {}
}
