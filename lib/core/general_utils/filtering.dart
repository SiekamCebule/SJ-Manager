import 'package:sj_manager/core/core_classes/country/country.dart';
import 'package:sj_manager/core/core_classes/sex.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';

List<CountryTeam> countryTeamsBySex(List<CountryTeam> teams, Sex sex) {
  return teams.where((team) => team.sex == sex).toList();
}

List<Country> countriesHavingTeam(List<CountryTeam> teams) {
  final countries = <Country>{};
  for (var team in teams) {
    countries.add(team.country);
  }
  return countries.toList();
}

List<CountryTeam> teamsByStars(List<CountryTeam> teams, {bool ascending = false}) {
  var copiedTeams = List.of(teams);
  final descending = !ascending;

  copiedTeams.sort((first, second) => first.facts.stars.compareTo(second.facts.stars));
  if (descending) {
    copiedTeams = copiedTeams.reversed.toList();
  }

  return copiedTeams;
}

extension ContainsAll on String {
  bool containsAllLetters({
    required String from,
  }) {
    Map<String, int> targetLetterCount = {};

    // Count occurrences of each letter in the target (searchText)
    for (var letter in from.split('')) {
      targetLetterCount[letter] = (targetLetterCount[letter] ?? 0) + 1;
    }

    // Check if source contains all letters from target with required frequency
    for (var letter in targetLetterCount.keys) {
      if (targetLetterCount[letter]! > RegExp(letter).allMatches(this).length) {
        return false;
      }
    }
    return true;
  }
}
