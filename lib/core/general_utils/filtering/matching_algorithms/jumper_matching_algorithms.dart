import 'package:sj_manager/core/general_utils/filtering/matching_algorithms/matching_by_text_algorithm.dart';

final class DefaultJumperMatchingByTextAlgorithm extends DefaultMatchingByTextAlgorithm {
  const DefaultJumperMatchingByTextAlgorithm({
    required String fullName,
    required super.text,
  }) : super(target: fullName);
}
