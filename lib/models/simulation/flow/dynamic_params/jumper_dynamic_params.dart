import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';
import 'package:sj_manager/models/user_db/psyche/level_of_consciousness_labels.dart';

class JumperDynamicParams {
  const JumperDynamicParams({
    required this.trainingConfig,
    required this.form,
    required this.jumpsConsistency,
    required this.physicalFatigue,
    required this.mentalFatique,
    required this.levelOfConsciousness,
  });

  final JumperTrainingConfig? trainingConfig;

  final double form; // 1-20
  final double jumpsConsistency; // 1-20

  final double physicalFatigue; // 1-20
  final double mentalFatique; // 1-20

  final LevelOfConsciousness levelOfConsciousness;

  JumperDynamicParams.empty()
      : this(
          trainingConfig: null,
          form: 0,
          jumpsConsistency: 0,
          physicalFatigue: 0,
          mentalFatique: 0,
          levelOfConsciousness: LevelOfConsciousness.fromMapOfConsciousness(
              LevelOfConsciousnessLabels.courage),
        );

  Json toJson() {
    return {
      'trainingConfig': trainingConfig?.toJson(),
      'form': form,
      'jumpsConsistency': jumpsConsistency,
      'physicalFatigue': physicalFatigue,
      'mentalFatique': mentalFatique,
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
      jumpsConsistency: json['jumpsConsistency'],
      physicalFatigue: json['physicalFatigue'],
      mentalFatique: json['mentalFatique'],
      levelOfConsciousness: LevelOfConsciousness(json['levelOfConsciousness']),
    );
  }

  JumperDynamicParams copyWith({
    JumperTrainingConfig? trainingConfig,
    double? form,
    double? jumpsConsistency,
    double? physicalFatigue,
    double? mentalFatique,
    LevelOfConsciousness? levelOfConsciousness,
  }) {
    return JumperDynamicParams(
      trainingConfig: trainingConfig ?? this.trainingConfig,
      form: form ?? this.form,
      jumpsConsistency: jumpsConsistency ?? this.jumpsConsistency,
      physicalFatigue: physicalFatigue ?? this.physicalFatigue,
      mentalFatique: mentalFatique ?? this.mentalFatique,
      levelOfConsciousness: levelOfConsciousness ?? this.levelOfConsciousness,
    );
  }
}
