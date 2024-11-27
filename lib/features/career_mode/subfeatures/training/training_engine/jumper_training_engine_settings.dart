import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/psyche/level_of_consciousness.dart';

class JumperTrainingEngineSettings {
  const JumperTrainingEngineSettings({
    required this.developmentPotentialFactorBase,
    required this.developmentPotentialDivider,
    required this.moraleFactorThreshold,
    required this.moraleFactorMultiplier,
    required this.fatigueFactorMultiplier,
    required this.takeoffBalanceEffectDivider,
    required this.takeoffRandomScaleBase,
    required this.takeoffRandomScaleBalanceDivider,
    required this.takeoffRandomCauchyDampingFactor,
    required this.takeoffDirectionalMultiplierDivider,
    required this.takeoffDeltaDampingExponent,
    required this.takeoffDeltaDampingBaseDivider,
    required this.flightBalanceEffectDivider,
    required this.flightRandomScaleBase,
    required this.flightRandomScaleBalanceDivider,
    required this.flightRandomCauchyDampingFactor,
    required this.flightDirectionalMultiplierDivider,
    required this.flightDeltaDampingExponent,
    required this.flightDeltaDampingBaseDivider,
    required this.landingBalanceEffectDivider,
    required this.landingRandomScaleBase,
    required this.landingRandomScaleBalanceDivider,
    required this.landingRandomCauchyDampingFactor,
    required this.landingDirectionalMultiplierDivider,
    required this.landingDeltaDampingExponent,
    required this.landingDeltaDampingBaseDivider,
    required this.formBalanceDivider,
    required this.formRandomScaleBase,
    required this.formRandomScaleBalanceDivider,
    required this.formRandomCauchyDampingFactor,
    required this.formDirectionalMultiplierDivider,
    required this.formDeltaDampingExponent,
    required this.formDeltaDampingBaseDivider,
    required this.consistencyMeanAvgBalanceDivider,
    required this.consistencyRandomScaleBase,
    required this.consistencyRandomCauchyDampingFactor,
    required this.consistencyBalanceDivider,
    required this.consistencyDirectionalMultiplierDivider,
    required this.consistencyDeltaDampingExponent,
    required this.consistencyDeltaDampingBaseDivider,
    required this.trainingFeelingTrainingFactorDeltaDivider,
    required this.trainingFeelingPointsDeviationByConsciousness,
  });

  final double developmentPotentialFactorBase;
  final double developmentPotentialDivider;
  final double moraleFactorThreshold;
  final double moraleFactorMultiplier;
  final double fatigueFactorMultiplier;

  // Takeoff parameters
  final double takeoffBalanceEffectDivider;
  final double takeoffRandomScaleBase;
  final double takeoffRandomScaleBalanceDivider;
  final double takeoffRandomCauchyDampingFactor;
  final double takeoffDirectionalMultiplierDivider;
  final double takeoffDeltaDampingExponent;
  final double takeoffDeltaDampingBaseDivider;

  // Flight parameters
  final double flightBalanceEffectDivider;
  final double flightRandomScaleBase;
  final double flightRandomScaleBalanceDivider;
  final double flightRandomCauchyDampingFactor;
  final double flightDirectionalMultiplierDivider;
  final double flightDeltaDampingExponent;
  final double flightDeltaDampingBaseDivider;

  // Landing parameters
  final double landingBalanceEffectDivider;
  final double landingRandomScaleBase;
  final double landingRandomScaleBalanceDivider;
  final double landingRandomCauchyDampingFactor;
  final double landingDirectionalMultiplierDivider;
  final double landingDeltaDampingExponent;
  final double landingDeltaDampingBaseDivider;

  // Form parameters
  final double formBalanceDivider;
  final double formRandomScaleBase;
  final double formRandomScaleBalanceDivider;
  final double formRandomCauchyDampingFactor;
  final double formDirectionalMultiplierDivider;
  final double formDeltaDampingExponent;
  final double formDeltaDampingBaseDivider;

  // Consistency parameters
  final double consistencyMeanAvgBalanceDivider;
  final double consistencyRandomScaleBase;
  final double consistencyRandomCauchyDampingFactor;
  final double consistencyBalanceDivider;
  final double consistencyDirectionalMultiplierDivider;
  final double consistencyDeltaDampingExponent;
  final double consistencyDeltaDampingBaseDivider;

  final double trainingFeelingTrainingFactorDeltaDivider;
  final Map<LevelOfConsciousnessLabels, double>
      trainingFeelingPointsDeviationByConsciousness;

  factory JumperTrainingEngineSettings.fromJson(Json json) {
    double parseDouble(dynamic value) =>
        value is int ? value.toDouble() : value as double;

    return JumperTrainingEngineSettings(
      developmentPotentialFactorBase: parseDouble(json['developmentPotentialFactorBase']),
      developmentPotentialDivider: parseDouble(json['developmentPotentialDivider']),
      moraleFactorThreshold:
          parseDouble(json['other_attributes']['moraleFactorThreshold']),
      moraleFactorMultiplier:
          parseDouble(json['other_attributes']['moraleFactorMultiplier']),
      fatigueFactorMultiplier:
          parseDouble(json['other_attributes']['fatigueFactorMultiplier']),
      takeoffBalanceEffectDivider:
          parseDouble(json['takeoff']['takeoffBalanceEffectDivider']),
      takeoffRandomScaleBase: parseDouble(json['takeoff']['takeoffRandomScaleBase']),
      takeoffRandomScaleBalanceDivider:
          parseDouble(json['takeoff']['takeoffRandomScaleBalanceDivider']),
      takeoffRandomCauchyDampingFactor:
          parseDouble(json['takeoff']['takeoffRandomCauchyDampingFactor']),
      takeoffDirectionalMultiplierDivider:
          parseDouble(json['takeoff']['takeoffDirectionalMultiplierDivider']),
      takeoffDeltaDampingExponent:
          parseDouble(json['takeoff']['takeoffDeltaDampingExponent']),
      takeoffDeltaDampingBaseDivider:
          parseDouble(json['takeoff']['takeoffDeltaDampingBaseDivider']),
      flightBalanceEffectDivider:
          parseDouble(json['flight']['flightBalanceEffectDivider']),
      flightRandomScaleBase: parseDouble(json['flight']['flightRandomScaleBase']),
      flightRandomScaleBalanceDivider:
          parseDouble(json['flight']['flightRandomScaleBalanceDivider']),
      flightRandomCauchyDampingFactor:
          parseDouble(json['flight']['flightRandomCauchyDampingFactor']),
      flightDirectionalMultiplierDivider:
          parseDouble(json['flight']['flightDirectionalMultiplierDivider']),
      flightDeltaDampingExponent:
          parseDouble(json['flight']['flightDeltaDampingExponent']),
      flightDeltaDampingBaseDivider:
          parseDouble(json['flight']['flightDeltaDampingBaseDivider']),
      landingBalanceEffectDivider:
          parseDouble(json['landing']['landingBalanceEffectDivider']),
      landingRandomScaleBase: parseDouble(json['landing']['landingRandomScaleBase']),
      landingRandomScaleBalanceDivider:
          parseDouble(json['landing']['landingRandomScaleBalanceDivider']),
      landingRandomCauchyDampingFactor:
          parseDouble(json['landing']['landingRandomCauchyDampingFactor']),
      landingDirectionalMultiplierDivider:
          parseDouble(json['landing']['landingDirectionalMultiplierDivider']),
      landingDeltaDampingExponent:
          parseDouble(json['landing']['landingDeltaDampingExponent']),
      landingDeltaDampingBaseDivider:
          parseDouble(json['landing']['landingDeltaDampingBaseDivider']),
      formBalanceDivider: parseDouble(json['form']['formBalanceDivider']),
      formRandomScaleBase: parseDouble(json['form']['formRandomScaleBase']),
      formRandomScaleBalanceDivider:
          parseDouble(json['form']['formRandomScaleBalanceDivider']),
      formRandomCauchyDampingFactor:
          parseDouble(json['form']['formRandomCauchyDampingFactor']),
      formDirectionalMultiplierDivider:
          parseDouble(json['form']['formDirectionalMultiplierDivider']),
      formDeltaDampingExponent: parseDouble(json['form']['formDeltaDampingExponent']),
      formDeltaDampingBaseDivider:
          parseDouble(json['form']['formDeltaDampingBaseDivider']),
      consistencyMeanAvgBalanceDivider:
          parseDouble(json['consistency']['consistencyMeanAvgBalanceDivider']),
      consistencyRandomScaleBase:
          parseDouble(json['consistency']['consistencyRandomScaleBase']),
      consistencyRandomCauchyDampingFactor:
          parseDouble(json['consistency']['consistencyRandomCauchyDampingFactor']),
      consistencyBalanceDivider:
          parseDouble(json['consistency']['consistencyBalanceDivider']),
      consistencyDirectionalMultiplierDivider:
          parseDouble(json['consistency']['consistencyDirectionalMultiplierDivider']),
      consistencyDeltaDampingExponent:
          parseDouble(json['consistency']['consistencyDeltaDampingExponent']),
      consistencyDeltaDampingBaseDivider:
          parseDouble(json['consistency']['consistencyDeltaDampingBaseDivider']),
      trainingFeelingTrainingFactorDeltaDivider:
          parseDouble(json['trainingFeelingTrainingFactorDeltaDivider']),
      trainingFeelingPointsDeviationByConsciousness:
          (json['trainingFeelingPointsDeviationByConsciousness'] as Json).map(
              (key, value) => MapEntry(
                  LevelOfConsciousnessLabels.values.byName(key), parseDouble(value))),
    );
  }
}

const sjmDefaultTrainingEngineSettings = JumperTrainingEngineSettings(
  developmentPotentialFactorBase: 1.0,
  developmentPotentialDivider: 10.0,
  moraleFactorThreshold: 0.0,
  moraleFactorMultiplier: 0.0,
  fatigueFactorMultiplier: 0.7,

  // Takeoff parameters
  takeoffBalanceEffectDivider: 30,
  takeoffRandomScaleBase: 0.10,
  takeoffRandomScaleBalanceDivider: 10.75,
  takeoffRandomCauchyDampingFactor: 0.0025,
  takeoffDirectionalMultiplierDivider: 10.0,
  takeoffDeltaDampingExponent: 2,
  takeoffDeltaDampingBaseDivider: 70,

  // Flight parameters
  flightBalanceEffectDivider: 30,
  flightRandomScaleBase: 0.10,
  flightRandomScaleBalanceDivider: 10.75,
  flightRandomCauchyDampingFactor: 0.0022,
  flightDirectionalMultiplierDivider: 1000,
  flightDeltaDampingExponent: 1,
  flightDeltaDampingBaseDivider: 70,

  // Landing parameters
  landingBalanceEffectDivider: 75,
  landingRandomScaleBase: 0.10,
  landingRandomScaleBalanceDivider: 10.75,
  landingRandomCauchyDampingFactor: 0.003,
  landingDirectionalMultiplierDivider: 1000.0,
  landingDeltaDampingExponent: 1,
  landingDeltaDampingBaseDivider: 5000,

  // Form parameters
  formBalanceDivider: 3.8,
  formRandomScaleBase: 0.15,
  formRandomScaleBalanceDivider: 8.5,
  formRandomCauchyDampingFactor: 0.0008,
  formDirectionalMultiplierDivider: 10.0,
  formDeltaDampingExponent: 2,
  formDeltaDampingBaseDivider: 9,

  // Consistency parameters
  consistencyBalanceDivider: 30,
  consistencyMeanAvgBalanceDivider: 0.12,
  consistencyRandomScaleBase: 0.3,
  consistencyRandomCauchyDampingFactor: 0.0001,
  consistencyDirectionalMultiplierDivider: 10.0,
  consistencyDeltaDampingExponent: 7,
  consistencyDeltaDampingBaseDivider: 20,

  trainingFeelingTrainingFactorDeltaDivider: 6,
  trainingFeelingPointsDeviationByConsciousness: {
    LevelOfConsciousnessLabels.shame: 23,
    LevelOfConsciousnessLabels.guilt: 22,
    LevelOfConsciousnessLabels.apathy: 21,
    LevelOfConsciousnessLabels.grief: 20,
    LevelOfConsciousnessLabels.fear: 18,
    LevelOfConsciousnessLabels.desire: 17,
    LevelOfConsciousnessLabels.anger: 16,
    LevelOfConsciousnessLabels.pride: 14,
    LevelOfConsciousnessLabels.courage: 12,
    LevelOfConsciousnessLabels.neutrality: 11,
    LevelOfConsciousnessLabels.willingness: 9.5,
    LevelOfConsciousnessLabels.acceptance: 8,
    LevelOfConsciousnessLabels.reason: 6,
    LevelOfConsciousnessLabels.love: 4,
    LevelOfConsciousnessLabels.joy: 2,
    LevelOfConsciousnessLabels.peace: 1,
    LevelOfConsciousnessLabels.enlightenment: 0,
  },
);
