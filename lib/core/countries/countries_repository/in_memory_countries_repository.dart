import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';
import 'package:sj_manager/core/errors/country_not_found_error.dart';

class InMemoryCountriesRepository with EquatableMixin implements CountriesRepository {
  const InMemoryCountriesRepository({
    required this.countries,
  });

  final Iterable<Country> countries;

  @override
  Iterable<Country> getAll() => countries;

  @override
  Country byCode(String code) {
    final toReturn = countries.singleWhereOrNull(
      (country) => country.code.toLowerCase() == code.toLowerCase(),
    );
    if (toReturn == null) {
      throw CountryByCodeNotFoundError(countryCode: code.toLowerCase());
    }
    return toReturn;
  }

  @override
  Country get none => byCode('none');

  @override
  List<Object?> get props => [countries];
}
