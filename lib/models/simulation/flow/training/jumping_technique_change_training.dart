import 'package:sj_manager/models/user_db/jumper/jumping_technique.dart';

enum JumpingTechniqueChangeTrainingType {
  decreaseRisk,
  maintain,
  increaseRisk,
}

JumpingTechnique getLessRiskyJumpingTechnique(JumpingTechnique source) {
  if (source.index > 0) {
    return JumpingTechnique.values[source.index - 1];
  } else {
    throw ArgumentError(
      'The source JumpingTechnique object is already the one with the least risk',
    );
  }
}

JumpingTechnique getMoreRiskyJumpingTechnique(JumpingTechnique source) {
  if (source.index < JumpingTechnique.values.length - 1) {
    return JumpingTechnique.values[source.index + 1];
  } else {
    throw ArgumentError(
      'The source JumpingTechnique object is already the one with the most risk',
    );
  }
}
