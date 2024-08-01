import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/db/event_series/event_series.dart';
import 'package:sj_manager/models/db/event_series/standings/score/concrete/classification_score.dart';

class ClassificationScoreCreatingContext extends EntityRelatedAlgorithmContext {
  const ClassificationScoreCreatingContext({
    required super.entity,
    required this.playedCompetitions,
    required this.eventSeries,
    required this.classificationScore,
  });

  final List<Competition> playedCompetitions;
  final EventSeries eventSeries;
  final ClassificationScore classificationScore;
}

abstract class ClassificationScoreCreator
    implements UnaryAlgorithm<ClassificationScore, ClassificationScoreCreatingContext> {}
