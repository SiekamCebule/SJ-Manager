import 'package:sj_manager/filters/filter.dart';
import 'package:sj_manager/models/country.dart';
import 'package:sj_manager/models/jumper/jumper.dart';

abstract class JumpersFilter extends Filter<Jumper> {
  const JumpersFilter();

  @override
  List<Jumper> call(List<Jumper> source);
}

final class JumpersFilterByCountry extends JumpersFilter {
  const JumpersFilterByCountry({
    required this.countries,
    this.noneCountry,
  });

  final Set<Country> countries;
  final Country? noneCountry;

  @override
  bool get isValid {
    return countries.isNotEmpty && !countries.contains(noneCountry);
  }

  @override
  List<Jumper> call(List<Jumper> source) {
    if (!isValid) return source;
    return source.where((jumper) => countries.contains(jumper.country)).toList();
  }

  @override
  List<Object?> get props => [countries];
}

final class JumpersFilterBySearch extends JumpersFilter {
  const JumpersFilterBySearch({
    required this.searchText,
  });

  final String searchText;

  @override
  bool get isValid => searchText.isNotEmpty;

  @override
  List<Jumper> call(List<Jumper> source) {
    if (!isValid) return source;
    return source.where(_shouldPass).toList();
  }

  bool _shouldPass(Jumper jumper) {
    final letters = jumper.nameAndSurname().toLowerCase().split('');
    final toContain = searchText.toLowerCase().split('');
    return toContain.every((letterToContain) {
      return letters.contains(letterToContain);
    });
  }

  @override
  List<Object?> get props => [searchText];
}
