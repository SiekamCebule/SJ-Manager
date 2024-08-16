import 'package:sj_manager/models/user_algorithms/unary_algorithm.dart';

class ClassificationScoreCreatorWrapper implements UnaryAlgorithm {
  const ClassificationScoreCreatorWrapper._internal(this.computeFunction);

  factory ClassificationScoreCreatorWrapper.wrap(UnaryAlgorithm algorithm) {
    return ClassificationScoreCreatorWrapper._internal(algorithm.compute);
  }

  final dynamic Function(dynamic input) computeFunction;

  @override
  compute(input) {
    return computeFunction(input);
  }
}
