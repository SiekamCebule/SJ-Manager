import 'package:osje_sim/osje_sim.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/entity_related_algorithm_context.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/unary_algorithm.dart';

class WindAveragingContext<E> extends EntityRelatedAlgorithmContext<E> {
  const WindAveragingContext({
    required super.entity,
    required this.windDuringJump,
  });

  final WindDuringJump windDuringJump;
}

abstract class WindAverager implements UnaryAlgorithm<Wind, WindAveragingContext> {}
