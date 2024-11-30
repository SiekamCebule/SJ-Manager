import 'dart:math';

import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_category.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_config.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/training_engine/jumper_training_engine_settings.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/entities/jumper_training_result.dart';
import 'package:sj_manager/features/career_mode/subfeatures/training/domain/training_engine/training_engine_entity.dart';
import 'package:sj_manager/core/general_utils/random/random.dart';
import 'package:sj_manager/core/career_mode/career_mode_utils/training_utils.dart';

class JumperTrainingEngine {
  JumperTrainingEngine({
    this.settings = sjmDefaultTrainingEngineSettings,
    required this.entity,
  });

  final JumperTrainingEngineSettings settings;
  final TrainingEngineEntity entity;

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
    if (entity.trainingConfig == null) {
      throw ArgumentError(
        'Entity\'s training config is null so cannot simulate the training',
      );
    }
    _trainingConfig = entity.trainingConfig!;
  }

  void _calculateDevelopmentPotentialFactor() {
    final fromMorale = entity.morale < settings.moraleFactorThreshold
        ? entity.morale * settings.moraleFactorMultiplier
        : 0;
    final fromFatigue = -entity.fatigue * settings.fatigueFactorMultiplier;

    _developmentPotentialFactor = settings.developmentPotentialFactorBase +
        ((fromMorale + fromFatigue) / settings.developmentPotentialDivider);
  }

  void _createResultObject() {
    _result = JumperTrainingResult(
      takeoffDelta: entity.takeoffQuality + _computeTakeoffDelta(),
      flightDelta: entity.flightQuality + _computeFlightDelta(),
      landingDelta: entity.landingQuality + _computeLandingDelta(),
      formDelta: entity.form + _computeFormDelta(),
      consistencyDelta: entity.jumpsConsistency + _computeConsistencyDelta(),
      fatigueDelta: entity.fatigue + _computeFatigueDelta(),
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

    final distanceFromCenter = (entity.takeoffQuality - 10).abs();
    var delta = random / settings.takeoffBalanceEffectDivider;
    final directionalMultiplier = (entity.takeoffQuality - 10) *
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

    final distanceFromCenter = (entity.flightQuality - 10).abs();
    var delta = random / settings.flightBalanceEffectDivider;
    final directionalMultiplier = (entity.flightQuality - 10) *
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

    final distanceFromCenter = (entity.landingQuality - 10).abs();
    var delta = random / settings.landingBalanceEffectDivider;
    final directionalMultiplier = (entity.landingQuality - 10) *
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
    final distanceFromCenter = (entity.form - 10).abs();
    var delta = random / settings.formBalanceDivider;
    final directionalMultiplier =
        (entity.form - 10) * delta.sign / settings.formDirectionalMultiplierDivider;
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
    final distanceFromCenter = (entity.jumpsConsistency - 10).abs();
    var delta = random / settings.consistencyBalanceDivider;
    final directionalMultiplier = (entity.jumpsConsistency - 10) *
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
