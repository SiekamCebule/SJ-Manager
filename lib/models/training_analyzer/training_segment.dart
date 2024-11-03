import 'package:sj_manager/models/simulation/flow/training/jumper_training_config.dart';

class TrainingSegment {
  const TrainingSegment({
    required this.start,
    required this.end,
    required this.scale,
    required this.trainingConfig,
  });

  final int start;
  final int end;
  final double scale;
  final JumperTrainingConfig trainingConfig;
}
