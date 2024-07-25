import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/repositories/generic/db_items_repo.dart';

class CountriesRepo extends DbItemsRepo<Country> {
  CountriesRepo({super.initial});

  Country byCode(String code) {
    return lastItems.singleWhere((country) => country.code == code);
  }

  Country get none => byCode('none');
}
