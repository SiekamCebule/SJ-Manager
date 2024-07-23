import 'package:rxdart/rxdart.dart';
import 'package:sj_manager/models/db/country.dart';
import 'package:sj_manager/repositories/database_editing/db_items_repo.dart';

class CountriesRepo extends DbItemsRepo<Country> {
  CountriesRepo({List<Country>? initial}) : _countries = initial ?? [] {
    _subject.add(_countries);
  }

  List<Country> _countries;
  final _subject = BehaviorSubject<List<Country>>();

  void setCountries(List<Country> countries) {
    _countries = countries;
    _subject.add(_countries);
  }

  @override
  ValueStream<List<Country>> get items => _subject.stream;

  Country byCode(String code) {
    return _countries.singleWhere((country) => country.code == code);
  }

  Country get none => byCode('none');

  void dispose() {
    _subject.close();
  }
}
