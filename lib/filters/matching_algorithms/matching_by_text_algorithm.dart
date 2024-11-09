import 'package:sj_manager/filters/matching_algorithms/match_algorithm.dart';

abstract class MatchingByTextAlgorithm<T> extends ItemMatchAlgorithm<T> {
  const MatchingByTextAlgorithm({
    required this.text,
  });

  final String text;

  @override
  List<Object?> get props => [text];
}
