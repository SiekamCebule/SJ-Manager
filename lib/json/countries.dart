import 'package:sj_manager/json/json_object_loader.dart';
import 'package:sj_manager/json/json_object_saver.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/repositories/countries/countries_repo.dart';

abstract interface class JsonCountryLoader<I> implements JsonObjectLoader<I, Country> {}

abstract interface class JsonCountrySaver<R> implements JsonObjectSaver<Country, R> {}

class CountryByCodeNotFoundError {
  CountryByCodeNotFoundError({
    required this.countryCode,
  });

  final String countryCode;

  @override
  String toString() {
    return 'Unable to find a country with the code of \'$countryCode\'';
  }
}

class JsonCountryLoaderByCode implements JsonCountryLoader<String> {
  const JsonCountryLoaderByCode({required this.repo});

  final CountriesRepo repo;

  @override
  Country load(String code) {
    try {
      return repo.last
          .singleWhere((country) => country.code.toLowerCase() == code.toLowerCase());
    } on StateError {
      throw CountryByCodeNotFoundError(countryCode: code);
    }
  }
}

class JsonCountryCodeSaver implements JsonCountrySaver<String> {
  const JsonCountryCodeSaver();

  @override
  String save(Country country) {
    return country.code;
  }
}
