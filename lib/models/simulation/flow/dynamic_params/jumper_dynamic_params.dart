import 'package:equatable/equatable.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/psyche/level_of_consciousness_labels.dart';

class JumperDynamicParams with EquatableMixin {
  const JumperDynamicParams({
    required this.trainingConfig,
    required this.jumpingTechniqueChangeTrainingDaysLeft,
    required this.form,
    required this.trainingEfficiencyFactor,
    required this.subjectiveTrainingEfficiency,
    required this.jumpsConsistency,
    required this.morale,
    required this.fatigue,
    required this.levelOfConsciousness,
  });

  final JumperTrainingConfig? trainingConfig;
  final int? jumpingTechniqueChangeTrainingDaysLeft;

  /// From 1 to 20
  final double form;

  /// From 0 to 1
  final double trainingEfficiencyFactor;

  /// From 0 to 1 (0% to 100%)
  final double? subjectiveTrainingEfficiency;

  /// From 1 to 20
  final double jumpsConsistency;

  /// From -1 to 1
  final double morale;

  /// From -1 to 1
  final double fatigue;

  /// From David Hawkins' Map of Consciousness
  final LevelOfConsciousness levelOfConsciousness;

  JumperDynamicParams.empty()
      : this(
          trainingConfig: null,
          jumpingTechniqueChangeTrainingDaysLeft: null,
          form: 0,
          trainingEfficiencyFactor: 0,
          subjectiveTrainingEfficiency: null,
          jumpsConsistency: 0,
          morale: 0,
          fatigue: 0,
          levelOfConsciousness: LevelOfConsciousness.fromMapOfConsciousness(
              LevelOfConsciousnessLabels.courage),
        );

  Json toJson() {
    return {
      'trainingConfig': trainingConfig?.toJson(),
      'jumpingTechniqueChangeTrainingDaysLeft': jumpingTechniqueChangeTrainingDaysLeft,
      'form': form,
      'trainingEfficiencyFactor': trainingEfficiencyFactor,
      'subjectiveTrainingEfficiency': subjectiveTrainingEfficiency,
      'jumpsConsistency': jumpsConsistency,
      'morale': morale,
      'fatigue': fatigue,
      'levelOfConsciousness': levelOfConsciousness.logarithmicValue,
    };
  }

  static JumperDynamicParams fromJson(Json json) {
    final trainingConfigJson = json['trainingConfig'];
    return JumperDynamicParams(
      trainingConfig: trainingConfigJson != null
          ? JumperTrainingConfig.fromJson(trainingConfigJson)
          : null,
      jumpingTechniqueChangeTrainingDaysLeft:
          json['jumpingTechniqueChangeTrainingDaysLeft'],
      form: json['form'],
      trainingEfficiencyFactor: json['trainingEfficiencyFactor'],
      subjectiveTrainingEfficiency: json['subjectiveTrainingEfficiency'],
      jumpsConsistency: json['jumpsConsistency'],
      morale: json['morale'],
      fatigue: json['fatigue'],
      levelOfConsciousness: LevelOfConsciousness(json['levelOfConsciousness']),
    );
  }

  JumperDynamicParams copyWith({
    JumperTrainingConfig? trainingConfig,
    int? jumpingTechniqueChangeTrainingDaysLeft,
    double? form,
    double? trainingEfficiencyFactor,
    double? subjectiveTrainingEfficiency,
    double? jumpsConsistency,
    double? morale,
    double? fatigue,
    LevelOfConsciousness? levelOfConsciousness,
  }) {
    return JumperDynamicParams(
      trainingConfig: trainingConfig ?? this.trainingConfig,
      jumpingTechniqueChangeTrainingDaysLeft: jumpingTechniqueChangeTrainingDaysLeft ??
          this.jumpingTechniqueChangeTrainingDaysLeft,
      form: form ?? this.form,
      trainingEfficiencyFactor: trainingEfficiencyFactor ?? this.trainingEfficiencyFactor,
      subjectiveTrainingEfficiency:
          subjectiveTrainingEfficiency ?? this.subjectiveTrainingEfficiency,
      jumpsConsistency: jumpsConsistency ?? this.jumpsConsistency,
      morale: morale ?? this.morale,
      fatigue: fatigue ?? this.fatigue,
      levelOfConsciousness: levelOfConsciousness ?? this.levelOfConsciousness,
    );
  }

  @override
  List<Object?> get props => [
        trainingConfig,
        jumpingTechniqueChangeTrainingDaysLeft,
        form,
        trainingEfficiencyFactor,
        subjectiveTrainingEfficiency,
        jumpsConsistency,
        morale,
        fatigue,
        levelOfConsciousness,
      ];
}
