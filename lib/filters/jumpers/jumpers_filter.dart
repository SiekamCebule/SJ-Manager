import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/filters/matching_algorithms/db_item_matching_by_text_algorithm.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';

abstract class JumpersFilter extends Filter<Jumper> {
  const JumpersFilter();

  @override
  List<Jumper> call(List<Jumper> source);
}

final class JumpersFilterByCountry extends JumpersFilter {
  const JumpersFilterByCountry({
    required this.countries,
    this.noneCountry,
  });

  final Set<Country> countries;
  final Country? noneCountry;

  @override
  bool get isValid {
    return countries.isNotEmpty && !countries.contains(noneCountry);
  }

  @override
  List<Jumper> call(List<Jumper> source) {
    if (!isValid) return source;
    return source.where((jumper) => countries.contains(jumper.country)).toList();
  }

  @override
  List<Object?> get props => [countries];
}

final class JumpersFilterBySearch extends JumpersFilter {
  const JumpersFilterBySearch({
    required this.searchAlgorithm,
  });

  final DbItemMatchingByTextAlgorithm<Jumper> searchAlgorithm;

  @override
  bool get isValid => searchAlgorithm.text.isNotEmpty;

  @override
  List<Jumper> call(List<Jumper> source) {
    if (!isValid) return source;
    return source.where(_shouldPass).toList();
  }

  bool _shouldPass(Jumper jumper) {
    return searchAlgorithm.matches(jumper);
  }

  @override
  List<Object?> get props => [searchAlgorithm];
}
