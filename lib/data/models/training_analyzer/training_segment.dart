import 'package:sj_manager/data/models/simulation/flow/training/jumper_training_config.dart';

class TrainingSegment {
  const TrainingSegment({
    required this.start,
    required this.end,
    required this.trainingConfig,
  });

  final int start;
  final int end;
  final JumperTrainingConfig trainingConfig;
}
