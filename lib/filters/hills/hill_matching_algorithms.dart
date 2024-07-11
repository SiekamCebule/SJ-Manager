import 'package:sj_manager/filters/matching_algorithms/db_item_matching_by_text_algorithm.dart';
import 'package:sj_manager/models/hill/hill.dart';

class DefaultHillMatchingByTextAlgorithm extends DbItemMatchingByTextAlgorithm<Hill> {
  const DefaultHillMatchingByTextAlgorithm({required super.text});

  @override
  bool matches(Hill item) {
    String searchText = text.toLowerCase();
    String hillName = item.name.toLowerCase();
    String hillLocality = item.locality.toLowerCase();

    bool containsAllLetters(String source, String target) {
      Map<String, int> targetLetterCount = {};

      for (var letter in target.split('')) {
        targetLetterCount[letter] = (targetLetterCount[letter] ?? 0) + 1;
      }

      for (var letter in targetLetterCount.keys) {
        if (targetLetterCount[letter]! > RegExp(letter).allMatches(source).length) {
          return false;
        }
      }
      return true;
    }

    return containsAllLetters(hillName, searchText) ||
        containsAllLetters(hillLocality, searchText);
  }
}
