import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/errors/country_not_found_error.dart';
import 'package:sj_manager/core/general_utils/json/json_object_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_object_saver.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';

abstract interface class JsonCountryLoader<I> implements JsonObjectLoader<I, Country> {}

abstract interface class JsonCountrySaver<R> implements JsonObjectSaver<Country, R> {}

class JsonCountryLoaderByCode implements JsonCountryLoader<String> {
  const JsonCountryLoaderByCode({required this.countriesRepository});

  final CountriesRepository countriesRepository;

  @override
  Future<Country> load(String code) async {
    try {
      return (await countriesRepository.getAll())
          .singleWhere((country) => country.code.toLowerCase() == code.toLowerCase());
    } on StateError {
      throw CountryByCodeNotFoundError(countryCode: code);
    }
  }
}

class JsonCountryLoaderCustom implements JsonCountryLoader<String> {
  const JsonCountryLoaderCustom({
    required this.getCountry,
  });

  final Country Function(String json) getCountry;

  @override
  Future<Country> load(String object) async {
    return getCountry(object);
  }
}

class JsonCountryLoaderNone implements JsonCountryLoader<void> {
  const JsonCountryLoaderNone();

  @override
  Future<Country> load(void object) async {
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
