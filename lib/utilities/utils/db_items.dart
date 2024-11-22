import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/domain/entities/game_variant/hill/hill.dart';
import 'package:sj_manager/features/database_editor/domain/entities/jumper/jumper_db_record.dart';

extension CountriesWithoutNone on Iterable<Country> {
  Iterable<Country> get withoutNoneCountry {
    return where((country) => country.code != 'none');
  }
}

extension JumpersByCountry<T extends JumperDbRecord> on Iterable<T> {
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

Map<Country, List<JumperDbRecord>> jumpersByCountry(
    Iterable<JumperDbRecord> jumpers, Iterable<Country> countries,
    {bool excludeEmpty = false}) {
  final map = <Country, List<JumperDbRecord>>{};
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
