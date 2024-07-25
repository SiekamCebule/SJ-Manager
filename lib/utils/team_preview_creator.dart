import 'package:sj_manager/models/db/hill/hill.dart';
import 'package:sj_manager/models/db/jumper/jumper.dart';
import 'package:sj_manager/models/db/jumps/simple_jump.dart';
import 'package:sj_manager/models/db/local_db_repo.dart';
import 'package:sj_manager/models/db/team/country_team.dart';
import 'package:sj_manager/models/db/team/team.dart';
import 'package:sj_manager/utils/db_items.dart';
import 'package:sj_manager/utils/iterable_random_access.dart';

abstract class TeamPreviewCreator<T extends Team> {
  const TeamPreviewCreator();

  int? stars(T team);
  SimpleJump? record(T team);
  Jumper? bestJumper(T team);
  Jumper? risingStar(T team);
  Hill? largestHill(T team);
}

class DefaultCountryTeamPreviewCreator extends TeamPreviewCreator<CountryTeam> {
  const DefaultCountryTeamPreviewCreator({
    required this.database,
  });

  final LocalDbRepo database;

  @override
  Hill? largestHill(CountryTeam team) {
    final fromCountry = database.hills.lastItems.fromCountryByCode(team.country.code);
    if (fromCountry.isEmpty) return null;
    return fromCountry.reduce((previous, current) {
      return previous.hs > current.hs ? previous : current;
    });
  }

  @override
  int? stars(CountryTeam team) {
    return team.facts.stars;
  }

  @override
  SimpleJump? record(CountryTeam team) {
    return team.facts.record;
  }

  @override
  Jumper? bestJumper(CountryTeam team) {
    // TODO: Some algorithm
    final fromCountry =
        database.maleJumpers.lastItems.fromCountryByCode(team.country.code);
    if (fromCountry.isEmpty) return null;
    return fromCountry.randomElement();
  }

  @override
  Jumper? risingStar(CountryTeam team) {
    // TODO: Some algorithm
    final fromCountry =
        database.maleJumpers.lastItems.fromCountryByCode(team.country.code);
    if (fromCountry.isEmpty) return null;
    return fromCountry.first;
  }
}
