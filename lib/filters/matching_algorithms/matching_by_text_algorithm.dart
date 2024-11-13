import 'package:sj_manager/filters/matching_algorithms/match_algorithm.dart';
import 'package:sj_manager/utils/filtering.dart';

abstract class MatchingByTextAlgorithm extends ItemMatchAlgorithm {
  const MatchingByTextAlgorithm({
    required this.target,
    required this.text,
  });

  final String target;
  final String text;

  @override
  List<Object?> get props => [text];
}

class DefaultMatchingByTextAlgorithm extends MatchingByTextAlgorithm {
  const DefaultMatchingByTextAlgorithm({
    required super.target,
    required super.text,
  });

  @override
  bool matches() {
    return target.toLowerCase().containsAllLetters(from: text.toLowerCase());
  }
}
