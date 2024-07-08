import 'package:sj_manager/models/country.dart';

abstract interface class CountriesApi {
  const CountriesApi();

  Future<void> loadFromSource();
  Future<void> saveToSource();

  Iterable<Country> get countries;
  Country? byCode(String code);
  Country get none;
}
