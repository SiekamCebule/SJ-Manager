import 'package:collection/collection.dart';
import 'package:sj_manager/core/country/country.dart';

class CountriesRepo {
  CountriesRepo({
    required this.countries,
  });

  final Iterable<Country> countries;

  Country byCode(String code) {
    final toReturn = countries.singleWhereOrNull(
      (country) => country.code.toLowerCase() == code.toLowerCase(),
    );
    if (toReturn == null) {
      throw CountryNotFoundError(countryCode: code.toLowerCase());
    }
    return toReturn;
  }

  Country get none => byCode('none');
}

class CountryNotFoundError extends Error {
  CountryNotFoundError({
    required this.countryCode,
  });

  final String countryCode;

  @override
  String toString() {
    return 'Didn\'t find a country with the code of \'$countryCode\'';
  }
}
