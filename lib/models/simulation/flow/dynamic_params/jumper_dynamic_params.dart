import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/psyche/level_of_consciousness_labels.dart';

class JumperDynamicParams {
  const JumperDynamicParams({
    required this.trainingConfig,
    required this.form,
    required this.trainingEffeciencyFactor,
    required this.jumpsConsistency,
    required this.morale,
    required this.fatigue,
    required this.levelOfConsciousness,
  });

  final JumperTrainingConfig? trainingConfig;

  /// From 1 to 20
  final double form;

  /// From 0 to 1
  final double trainingEffeciencyFactor;

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
          form: 0,
          trainingEffeciencyFactor: 0,
          jumpsConsistency: 0,
          morale: 0,
          fatigue: 0,
          levelOfConsciousness: LevelOfConsciousness.fromMapOfConsciousness(
              LevelOfConsciousnessLabels.courage),
        );

  Json toJson() {
    return {
      'trainingConfig': trainingConfig?.toJson(),
      'form': form,
      'trainingEffeciencyFactor': trainingEffeciencyFactor,
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
      form: json['form'],
      trainingEffeciencyFactor: json['trainingEffeciencyFactor'],
      jumpsConsistency: json['jumpsConsistency'],
      morale: json['morale'],
      fatigue: json['fatigue'],
      levelOfConsciousness: LevelOfConsciousness(json['levelOfConsciousness']),
    );
  }

  JumperDynamicParams copyWith({
    JumperTrainingConfig? trainingConfig,
    double? form,
    double? trainingEffeciencyFactor,
    double? jumpsConsistency,
    double? morale,
    double? fatigue,
    LevelOfConsciousness? levelOfConsciousness,
  }) {
    return JumperDynamicParams(
      trainingConfig: trainingConfig ?? this.trainingConfig,
      form: form ?? this.form,
      trainingEffeciencyFactor: trainingEffeciencyFactor ?? this.trainingEffeciencyFactor,
      jumpsConsistency: jumpsConsistency ?? this.jumpsConsistency,
      morale: morale ?? this.morale,
      fatigue: fatigue ?? this.fatigue,
      levelOfConsciousness: levelOfConsciousness ?? this.levelOfConsciousness,
    );
  }
}
