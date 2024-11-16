import 'package:sj_manager/utilities/json/json_object_loader.dart';
import 'package:sj_manager/utilities/json/json_object_saver.dart';
import 'package:sj_manager/data/models/database/country/country.dart';
import 'package:sj_manager/domain/repository_interfaces/countries/countries_repo.dart';

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
      return repo.countries
          .singleWhere((country) => country.code.toLowerCase() == code.toLowerCase());
    } on StateError {
      throw CountryByCodeNotFoundError(countryCode: code);
    }
  }
}

class JsonCountryLoaderNone implements JsonCountryLoader<void> {
  const JsonCountryLoaderNone();

  @override
  Country load(void object) {
    return const Country.emptyNone();
  }
}

class JsonCountryCodeSaver implements JsonCountrySaver<String> {
  const JsonCountryCodeSaver();

  @override
  String save(Country country) {
    return country.code;
  }
}
