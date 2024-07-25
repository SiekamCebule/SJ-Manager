import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/sex.dart';
import 'package:sj_manager/models/db/team/country_team.dart';

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
