import 'package:sj_manager/filters/matching_algorithms/matching_by_text_algorithm.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';
import 'package:sj_manager/utils/filtering.dart';

final class DefaultJumperMatchingByTextAlgorithm extends MatchingByTextAlgorithm<Jumper> {
  const DefaultJumperMatchingByTextAlgorithm({required super.text});

  @override
  bool matches(Jumper item) {
    String searchText = text.toLowerCase();
    String fullName = '${item.name} ${item.surname}'.toLowerCase();
    return fullName.containsAllLetters(from: searchText);
  }
}
