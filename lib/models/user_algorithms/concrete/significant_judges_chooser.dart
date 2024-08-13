import 'package:sj_manager/models/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/simulation_db/standings/score/judge_evaluation.dart';

class SignificantJudgesChoosingContext extends EntityRelatedAlgorithmContext {
  const SignificantJudgesChoosingContext({
    required super.entity,
    required this.judges,
  });

  final Set<JudgeEvaluation> judges;
}

abstract class SignificantJudgesChooser
    implements UnaryAlgorithm<Set<JudgeEvaluation>, SignificantJudgesChoosingContext> {}
