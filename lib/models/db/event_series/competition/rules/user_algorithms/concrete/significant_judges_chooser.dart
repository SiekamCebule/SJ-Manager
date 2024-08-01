import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/db/event_series/standings/score/judge_evaluation.dart';

class SignificantJudgesChoosingContext extends EntityRelatedAlgorithmContext {
  const SignificantJudgesChoosingContext({
    required super.entity,
    required this.judges,
  });

  final Set<JudgeEvaluation> judges;
}

abstract class SignificantJudgesChooser
    implements UnaryAlgorithm<Set<JudgeEvaluation>, SignificantJudgesChoosingContext> {}
