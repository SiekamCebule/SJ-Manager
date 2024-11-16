import 'package:sj_manager/utilities/filters/matching_algorithms/matching_by_text_algorithm.dart';

final class DefaultHillMatchingByTextAlgorithm extends DefaultMatchingByTextAlgorithm {
  const DefaultHillMatchingByTextAlgorithm({
    required String locality,
    required String name,
    required super.text,
  }) : super(target: '$locality$name');
}
