import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/db/event_series/standings/score/concrete/competition_scores.dart';
import 'package:sj_manager/models/db/event_series/standings/score/concrete/single_jump_score.dart';

class CompetitionScoreCreatingContext extends EntityRelatedAlgorithmContext {
  const CompetitionScoreCreatingContext({
    required super.entity,
    required this.lastJumpScore,
    required this.currentCompetitionScore,
  });

  final SingleJumpScore lastJumpScore;
  final CompetitionScore? currentCompetitionScore;
}

abstract class CompetitionScoreCreator
    implements UnaryAlgorithm<CompetitionScore, CompetitionScoreCreatingContext> {}
