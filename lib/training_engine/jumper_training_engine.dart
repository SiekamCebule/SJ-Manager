import 'package:sj_manager/models/simulation/flow/dynamic_params/jumper_dynamic_params.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/training_engine/jumper_training_result.dart';
import 'package:sj_manager/utils/random/random.dart';

class JumperTrainingEngine {
  JumperTrainingEngine({
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
  late double _formStability;
  late double _jumpsConsistency;
  late double _fatigue;

  JumperTrainingResult doTraining() {
    _setUp();
    _calculateDevelopmentPotentialFactor();
    _simulateTakeoffTraining();
    _simulateFlightTraining();
    _simulateLandingTraining();
    _simulateFormTraining();
    _simulateJumpsConsistencyTraining();
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

    const negativeRandomMax = potentialRandomForOnePoint * 5;
    final negativeRandom = linearRandomDouble(0, negativeRandomMax);

    final positiveRandomMax =
        (_developmentPotentialFactor * developmentPotentialMultiplier) *
            (dynamicParams.trainingEfficiencyFactor * trainingEfficiencyMultiplier) *
            (potentialRandomForOnePoint * formPoints) *
            (1.0 / _form);

    final positiveRandom = linearRandomDouble(0, positiveRandomMax);
    final random = (negativeRandom + positiveRandom) * scaleFactor;

    _form += random;
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
