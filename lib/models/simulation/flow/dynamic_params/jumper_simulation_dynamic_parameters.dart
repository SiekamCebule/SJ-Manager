import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';

class JumperSimulationDynamicParameters {
  const JumperSimulationDynamicParameters({
    required this.trainingConfig,
  });

  final JumperTrainingConfig? trainingConfig;

  JumperSimulationDynamicParameters copyWith({
    JumperTrainingConfig? trainingConfig,
  }) {
    return JumperSimulationDynamicParameters(
      trainingConfig: trainingConfig ?? this.trainingConfig,
    );
  }

  Json toJson() {
    return {
      'trainingConfig': trainingConfig?.toJson(),
    };
  }

  static JumperSimulationDynamicParameters fromJson(Json json) {
    final trainingConfigJson = json['trainingConfig'];
    return JumperSimulationDynamicParameters(
      trainingConfig: trainingConfigJson != null
          ? JumperTrainingConfig.fromJson(trainingConfigJson)
          : null,
    );
  }
}
