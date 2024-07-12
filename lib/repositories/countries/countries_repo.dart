import 'package:sj_manager/models/country.dart';

class CountriesRepo {
  CountriesRepo({List<Country>? initial}) : _countries = initial ?? [];

  List<Country> _countries;

  void setCountries(List<Country> countries) {
    _countries = countries;
  }

  List<Country> get countries => _countries;

  Country byCode(String code) {
    return _countries.singleWhere((country) => country.code == code);
  }

  Country get none => byCode('none');
}
