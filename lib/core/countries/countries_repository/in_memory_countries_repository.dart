import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:sj_manager/core/classes/country/country.dart';
import 'package:sj_manager/core/countries/countries_repository/countries_repository.dart';

class InMemoryCountriesRepository with EquatableMixin implements CountriesRepository {
  const InMemoryCountriesRepository({
    required this.countries,
  });

  final Iterable<Country> countries;

  @override
  Future<Iterable<Country>> getAll() async => countries;

  @override
  Future<Country> byCode(String code) async {
    final toReturn = countries.singleWhereOrNull(
      (country) => country.code.toLowerCase() == code.toLowerCase(),
    );
    if (toReturn == null) {
      throw CountryNotFoundError(countryCode: code.toLowerCase());
    }
    return toReturn;
  }

  @override
  Future<Country> get none async => byCode('none');

  @override
  List<Object?> get props => [countries];
}
