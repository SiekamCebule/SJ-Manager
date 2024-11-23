import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/general_utils/filtering/filter/filter.dart';
import 'package:sj_manager/core/mixins/country_mixin.dart';
import 'package:sj_manager/core/mixins/name_and_surname_mixin.dart';
import 'package:sj_manager/core/general_utils/filtering/matching_algorithms/matching_by_text_algorithm.dart';

class NoFilter<T> implements Filter<T> {
  @override
  Iterable<T> call(Iterable<T> source) {
    return source;
  }

  @override
  bool get isValid => false;
}

class NameSurnameFilter<T extends NameAndSurnameMixin> implements Filter<T> {
  const NameSurnameFilter({
    required this.text,
  });

  final String text;

  @override
  Iterable<T> call(Iterable<T> source) {
    bool shouldPass(NameAndSurnameMixin data) {
      final base = data.nameAndSurname();
      return DefaultMatchingByTextAlgorithm(target: base, text: text).matches();
    }

    return source.where(shouldPass);
  }

  @override
  bool get isValid => text.isNotEmpty;
}

class CountryFilter<T extends CountryMixin> implements Filter<T> {
  const CountryFilter({
    required this.country,
  });

  final Country? country;

  @override
  Iterable<T> call(Iterable<T> source) {
    bool shouldPass(CountryMixin data) {
      return data.country == country;
    }

    return source.where(shouldPass);
  }

  @override
  bool get isValid => country != null;
}
