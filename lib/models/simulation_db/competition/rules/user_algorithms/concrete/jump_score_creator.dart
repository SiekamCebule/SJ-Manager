import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/single_jump_score.dart';

class JumpScoreCreatingContext extends EntityRelatedAlgorithmContext {
  const JumpScoreCreatingContext({
    required super.entity,
    required this.jumpRecord,
  });

  final JumpSimulationRecord jumpRecord;
}

abstract class JumpScoreCreator
    implements UnaryAlgorithm<SingleJumpScore, JumpScoreCreatingContext> {}
