import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class CountriesRepo extends ItemsRepo<Country> {
  CountriesRepo({super.initial});

  Country byCode(String code) {
    return last.singleWhere((country) => country.code == code);
  }

  Country get none => byCode('none');
}
