import 'package:sj_manager/models/db/country.dart';
import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/ui/reusable_widgets/countries/country_flag.dart';

class DbFileSystemEntityNames {
  const DbFileSystemEntityNames({
    required this.maleJumpers,
    required this.femaleJumpers,
    required this.hills,
    required this.countries,
    required this.countryFlags,
  });

  final String maleJumpers;
  final String femaleJumpers;
  final String hills;
  final String countries;
  final String countryFlags;

  String byGenericType<T>() {
    if (T == MaleJumper) return maleJumpers;
    if (T == FemaleJumper) return femaleJumpers;
    if (T == Hill) return hills;
    if (T == Country) return countries;
    if (T == CountryFlag) return countryFlags;
    throw StateError('Invalid generic type ($T)');
  }
}
