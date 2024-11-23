import 'package:sj_manager/core/mixins/country_mixin.dart';

extension FromCountryByCode<T extends CountryMixin> on Iterable<T> {
  Iterable<T> fromCountryByCode(String code) =>
      where((item) => item.country.code == code);
}
