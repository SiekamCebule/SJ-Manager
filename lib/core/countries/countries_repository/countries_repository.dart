import 'package:sj_manager/core/classes/country/country.dart';

abstract interface class CountriesRepository {
  Future<Iterable<Country>> getAll();
  Future<Country> byCode(String code);
  Future<Country> get none;
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
