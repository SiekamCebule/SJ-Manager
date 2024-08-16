import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';
import 'package:sj_manager/models/simulation_db/standings/score/concrete/classification_score.dart';

class ClassificationScoreCreatingContext<E> extends EntityRelatedAlgorithmContext<E> {
  const ClassificationScoreCreatingContext({
    required super.entity,
    required this.playedCompetitions,
    //required this.eventSeries, // TODO: Unhide it
    required this.classificationScore,
  });

  final List<Competition> playedCompetitions;
  //final EventSeries eventSeries;
  final ClassificationScore classificationScore;
}

abstract class ClassificationScoreCreator<S extends ClassificationScore>
    implements UnaryAlgorithm<ClassificationScoreCreatingContext, S> {}
