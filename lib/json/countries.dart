import 'package:sj_manager/json/json_object_loader.dart';
import 'package:sj_manager/json/json_object_saver.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/repositories/countries/countries_api.dart';

abstract interface class JsonCountryLoader<I> implements JsonObjectLoader<I, Country> {}

abstract interface class JsonCountrySaver<R> implements JsonObjectSaver<Country, R> {}

class JsonCountryLoaderByCode implements JsonCountryLoader<String> {
  const JsonCountryLoaderByCode({required this.repo});

  final CountriesApi repo;

  @override
  Country load(String code) {
    return repo.countries.singleWhere((country) => country.code == code);
  }
}

class JsonCountryCodeSaver implements JsonCountrySaver<String> {
  const JsonCountryCodeSaver();

  @override
  String save(Country country) {
    return country.code;
  }
}
