import 'package:collection/collection.dart';
import 'package:sj_manager/models/user_db/country/country.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class CountriesRepo extends ItemsRepo<Country> {
  CountriesRepo({super.initial});

  Country byCode(String code) {
    final toReturn = last.singleWhereOrNull(
      (country) => country.code.toLowerCase() == code.toLowerCase(),
    );
    if (toReturn == null) {
      throw CountryNotFoundError(countryCode: code.toLowerCase());
    }
    return toReturn;
  }

  Country get none => byCode('none');
}

class CountryNotFoundError extends Error {
  CountryNotFoundError({
    required this.countryCode,
  });

  final String countryCode;

  @override
  String toString() {
    return 'Didn\'t find a country with the code of \'$countryCode\'';
  }
}
