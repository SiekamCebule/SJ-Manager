import 'package:sj_manager/filters/matching_algorithms/matching_by_text_algorithm.dart';
import 'package:sj_manager/models/user_db/hill/hill.dart';
import 'package:sj_manager/utils/filtering.dart';

class DefaultHillMatchingByTextAlgorithm extends MatchingByTextAlgorithm<Hill> {
  const DefaultHillMatchingByTextAlgorithm({required super.text});

  @override
  bool matches(Hill item) {
    String searchText = text.toLowerCase();
    String hillName = item.name.toLowerCase();
    String hillLocality = item.locality.toLowerCase();

    return hillName.containsAllLetters(from: searchText) ||
        hillLocality.containsAllLetters(from: searchText);
  }
}
