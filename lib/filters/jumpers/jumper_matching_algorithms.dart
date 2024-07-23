import 'package:sj_manager/filters/matching_algorithms/db_item_matching_by_text_algorithm.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';

final class DefaultJumperMatchingByTextAlgorithm
    extends DbItemMatchingByTextAlgorithm<Jumper> {
  const DefaultJumperMatchingByTextAlgorithm({required super.text});

  @override
  bool matches(Jumper item) {
    String searchText = text.toLowerCase();
    String fullName = '${item.name} ${item.surname}'.toLowerCase();

    bool containsAllLetters(String source, String target) {
      Map<String, int> targetLetterCount = {};

      // Count occurrences of each letter in the target (searchText)
      for (var letter in target.split('')) {
        targetLetterCount[letter] = (targetLetterCount[letter] ?? 0) + 1;
      }

      // Check if source contains all letters from target with required frequency
      for (var letter in targetLetterCount.keys) {
        if (targetLetterCount[letter]! > RegExp(letter).allMatches(source).length) {
          return false;
        }
      }
      return true;
    }

    return containsAllLetters(fullName, searchText);
  }
}
