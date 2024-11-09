import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/filters/matching_algorithms/matching_by_text_algorithm.dart';
import 'package:sj_manager/filters/mixins.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/models/user_db/jumper/jumper.dart';

class ConcreteJumpersFilterWrapper<T extends Jumper, F extends JumpersFilter>
    extends Filter<T> {
  const ConcreteJumpersFilterWrapper({required this.filter});

  final F filter;

  @override
  List<T> call(List<T> source) {
    final filtered = filter.call(source);
    return filtered.cast();
  }

  @override
  List<Object?> get props => [filter.props];

  @override
  bool get isValid => filter.isValid;
}

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

final class JumpersFilterBySearch extends JumpersFilter with SearchFilter {
  const JumpersFilterBySearch({
    required this.searchAlgorithm,
  });

  final MatchingByTextAlgorithm<Jumper> searchAlgorithm;

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
