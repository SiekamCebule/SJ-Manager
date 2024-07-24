import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/country/country_facts.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';

extension CountriesWithoutNone on Iterable<Country> {
  Iterable<Country> get withoutNoneCountry {
    return where((country) => country.code != 'none');
  }
}

extension JumpersByCountry<T extends Jumper> on Iterable<T> {
  Iterable<T> fromCountry(Country country) {
    return where((jumper) => jumper.country == country);
  }

  Iterable<T> fromCountryByCode(String countryCode) {
    return where((jumper) => jumper.country.code == countryCode);
  }
}

extension HillByCountry on Iterable<Hill> {
  Iterable<Hill> fromCountry(Country country) {
    return where((hill) => hill.country == country);
  }

  Iterable<Hill> fromCountryByCode(String countryCode) {
    return where((hill) => hill.country.code == countryCode);
  }
}

extension CountryFactByCountry on Iterable<CountryFacts> {
  CountryFacts? byCountryCode(String countryCode) {
    return where((facts) => facts.countryCode == countryCode).singleOrNull;
  }
}

Map<Country, List<Jumper>> jumpersByCountry(
    Iterable<Jumper> jumpers, Iterable<Country> countries,
    {bool excludeEmpty = false}) {
  final map = <Country, List<Jumper>>{};
  for (var country in countries) {
    map[country] = [];
  }
  for (var jumper in jumpers) {
    map[jumper.country]!.add(jumper);
  }
  if (excludeEmpty) {
    map.removeWhere((country, jumpers) => jumpers.isEmpty);
  }

  return map;
}
