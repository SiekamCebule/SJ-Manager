import 'package:sj_manager/filters/matching_algorithms/match_algorithm.dart';

abstract class DbItemMatchingByTextAlgorithm<T> extends ItemMatchAlgorithm<T> {
  const DbItemMatchingByTextAlgorithm({
    required this.text,
  });

  final String text;

  @override
  List<Object?> get props => [text];
}
