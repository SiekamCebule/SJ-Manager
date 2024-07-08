import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/jumper.dart';

abstract interface class JumpersFilter implements Filter<Jumper> {
  const JumpersFilter();

  @override
  List<Jumper> call(List<Jumper> source);
}

final class JumpersFilterByCountry implements JumpersFilter {
  JumpersFilterByCountry({
    required this.countries,
  });

  Set<Country> countries;

  @override
  List<Jumper> call(List<Jumper> source) {
    if (countries.isEmpty) return source;
    return source.where((jumper) => countries.contains(jumper.country)).toList();
  }
}
