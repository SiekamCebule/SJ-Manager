import 'dart:math';

import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper_skills.dart';
import 'package:sj_manager/training_engine/jumper_training_engine_settings.dart';
import 'package:sj_manager/training_engine/jumper_training_result.dart';
import 'package:sj_manager/utils/random/random.dart';

class JumperTrainingEngine {
  JumperTrainingEngine({
    this.settings = sjmDefaultTrainingEngineSettings,
    required this.jumperSkills,
    required this.dynamicParams,
    required this.scaleFactor,
  });

  final JumperTrainingEngineSettings settings;
  final JumperSkills jumperSkills;
  final JumperDynamicParams dynamicParams;
  final double scaleFactor;

  late JumperTrainingConfig _trainingConfig;
  late double _developmentPotentialFactor;
  late Map<JumperTrainingCategory, double> _trainingFactor;
  late Map<JumperTrainingCategory, double> _trainingFeeling;
  late JumperTrainingResult _result;

  JumperTrainingResult doTraining() {
    _setUp();
    _calculateDevelopmentPotentialFactor();
    _createResultObject();
    simulateInjuries();
    return _result;
  }

  void _setUp() {
    if (dynamicParams.trainingConfig == null) {
      throw ArgumentError(
        'Jumper\'s ($jumperSkills) training config is null so cannot simulate the training',
      );
    }
    _trainingConfig = dynamicParams.trainingConfig!;
    _trainingFeeling = {};
  }

  void _calculateDevelopmentPotentialFactor() {
    final fromMorale = dynamicParams.morale < settings.moraleFactorThreshold
        ? dynamicParams.morale * settings.moraleFactorMultiplier
        : 0;
    final fromFatigue = -dynamicParams.fatigue * settings.fatigueFactorMultiplier;

    _developmentPotentialFactor = settings.developmentPotentialFactorBase +
        ((fromMorale + fromFatigue) / settings.developmentPotentialDivider);
  }

  void _createResultObject() {
    _result = JumperTrainingResult(
      skills: jumperSkills.copyWith(
        takeoffQuality: jumperSkills.takeoffQuality + _computeTakeoffDelta(),
        flightQuality: jumperSkills.flightQuality + _computeFlightDelta(),
        landingQuality: jumperSkills.landingQuality + _computeLandingDelta(),
      ),
      form: dynamicParams.form + _computeFormDelta(),
      jumpsConsistency: dynamicParams.jumpsConsistency + _computeConsistencyDelta(),
      fatigue: dynamicParams.fatigue + _computeFatigueDelta(),
      trainingFeeling: _trainingFeeling,
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

    final distanceFromCenter = (jumperSkills.takeoffQuality - 10).abs();
    var delta = random / settings.takeoffBalanceEffectDivider;
    final directionalMultiplier = (jumperSkills.takeoffQuality - 10) *
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

    final distanceFromCenter = (jumperSkills.flightQuality - 10).abs();
    var delta = random / settings.flightBalanceEffectDivider;
    final directionalMultiplier = (jumperSkills.flightQuality - 10) *
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

    final distanceFromCenter = (jumperSkills.landingQuality - 10).abs();
    var delta = random / settings.landingBalanceEffectDivider;
    final directionalMultiplier = (jumperSkills.landingQuality - 10) *
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
    final distanceFromCenter = (dynamicParams.form - 10).abs();
    var delta = random / settings.formBalanceDivider;
    final directionalMultiplier = (dynamicParams.form - 10) *
        delta.sign /
        settings.formDirectionalMultiplierDivider;
    final exponentiationBase = 1 +
        (distanceFromCenter / settings.formDeltaDampingBaseDivider) *
            (1 + directionalMultiplier);
    final dampingDivider = pow(exponentiationBase, settings.formDeltaDampingExponent);

    delta /= dampingDivider;

    return delta;
  }

  double _computeConsistencyDelta() {
    final avgBalance = (_trainingConfig.balance[JumperTrainingCategory.takeoff]! * 27.5 +
            (_trainingConfig.balance[JumperTrainingCategory.flight]! * 27.5) +
            (_trainingConfig.balance[JumperTrainingCategory.form]! * 40) +
            (_trainingConfig.balance[JumperTrainingCategory.landing]! * 5)) /
        100;

    final mean = -avgBalance / settings.consistencyMeanAvgBalanceDivider;
    final scale = settings.consistencyRandomScaleBase;
    final random = dampedCauchyDistributionRandom(
      mean,
      scale,
      settings.consistencyRandomCauchyDampingFactor,
    );
    // Tłumienie delty
    final distanceFromCenter = (dynamicParams.jumpsConsistency - 10).abs();
    var delta = random / settings.consistencyBalanceDivider;
    final directionalMultiplier = (dynamicParams.jumpsConsistency - 10) *
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

  double _computeTrainingFeeling({
    required JumperTrainingCategory trainingCategory,
    required double trainingFactorDelta,
  }) {
    var percentagePointsDeviation =
        settings.trainingFeelingPointsDeviationByConsciousness[
            dynamicParams.levelOfConsciousness.label]!;

    var trainingFeeling = _trainingFactor[trainingCategory]!;
    var randomMin = -percentagePointsDeviation / 100;
    var randomMax = percentagePointsDeviation / 100;
    trainingFeeling += linearRandomDouble(randomMin, randomMax);
    trainingFeeling -=
        (trainingFactorDelta / settings.trainingFeelingTrainingFactorDeltaDivider);

    return trainingFeeling;
  }
}
