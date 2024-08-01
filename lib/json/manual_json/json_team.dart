import 'package:sj_manager/json/countries.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/user_db/team/country_team.dart';
import 'package:sj_manager/models/user_db/team/team.dart';

class JsonTeamParser {
  JsonTeamParser({required this.countryLoader});

  final JsonCountryLoader countryLoader;

  Team parseTeam(Json json) {
    switch (json['type']) {
      case 'country_team':
        return CountryTeam.fromJson(json, countryLoader: countryLoader);
      default:
        throw UnsupportedError('Unknown team type: ${json['type']}');
    }
  }
}

class JsonTeamSerializer {
  JsonTeamSerializer({required this.countrySaver});

  final JsonCountrySaver countrySaver;

  Json serializeTeam(Team team) {
    if (team is CountryTeam) {
      return team.toJson(countrySaver: countrySaver);
    } else {
      throw UnsupportedError('Unknown team type');
    }
  }
}
