import 'package:sj_manager/core/core_classes/country/country.dart';

abstract interface class CountriesRepository {
  Iterable<Country> getAll();
  Country byCode(String code);
  Country get none;
}
