import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/training/jumper_training_config.dart';

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
