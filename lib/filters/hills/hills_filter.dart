import 'package:sj_manager/filters/matching_algorithms/db_item_matching_by_text_algorithm.dart';
import 'package:sj_manager/models/hill/hill_type_by_size.dart';
import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/hill/hill.dart';

abstract class HillsFilter extends Filter<Hill> {
  const HillsFilter();

  @override
  List<Hill> call(List<Hill> source);
}

final class HillsFilterByCountry extends HillsFilter {
  const HillsFilterByCountry({
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
  List<Hill> call(List<Hill> source) {
    if (!isValid) return source;
    return source.where((hill) => countries.contains(hill.country)).toList();
  }

  @override
  List<Object?> get props => [countries];
}

final class HillsFilterBySearch extends HillsFilter {
  const HillsFilterBySearch({
    required this.searchAlgorithm,
  });

  final DbItemMatchingByTextAlgorithm<Hill> searchAlgorithm;

  @override
  bool get isValid => searchAlgorithm.text.isNotEmpty;

  @override
  List<Hill> call(List<Hill> source) {
    if (!isValid) return source;
    return source.where(_shouldPass).toList();
  }

  bool _shouldPass(Hill hill) {
    return searchAlgorithm.matches(hill);
  }

  @override
  List<Object?> get props => [searchAlgorithm];
}

final class HillsFilterByTypeBySie extends HillsFilter {
  const HillsFilterByTypeBySie({
    required this.type,
  });

  final HillTypeBySize? type;

  @override
  bool get isValid => type != null;

  @override
  List<Hill> call(List<Hill> source) {
    if (!isValid) return source;
    return source.where((hill) => hill.typeBySize == type).toList();
  }

  @override
  List<Object?> get props => [
        type,
      ];
}
