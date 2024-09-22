import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/json/utils/enums.dart';
import 'package:sj_manager/models/user_db/team/competition_team.dart';
import 'package:sj_manager/models/user_db/team/country_team/country_team.dart';
import 'package:sj_manager/models/user_db/team/subteam.dart';
import 'package:sj_manager/models/user_db/team/team.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class TeamSerializer implements SimulationDbPartSerializer<Team> {
  const TeamSerializer({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  Json serialize(Team team) {
    if (team is CountryTeam) {
      return _serializeCountryTeam(team);
    } else if (team is CompetitionTeam) {
      return _serializeCompetitionTeam(team);
    } else if (team is Subteam) {
      return _serializeSubteam(team);
    } else {
      throw ArgumentError('Cannot serialize a team of type ${team.runtimeType}');
    }
  }

  Json _serializeCountryTeam(CountryTeam team) {
    return {
      'type': 'country_team',
      'sex': sexEnumMap[team.sex],
      'countryCode': team.country.code,
      'facts': {
        'stars': team.facts.stars,
        'record': team.facts.record != null
            ? {
                'jumperNameAndSurname': team.facts.record!.jumperNameAndSurname,
                'distance': team.facts.record!.distance,
              }
            : null,
      },
    };
  }

  Json _serializeCompetitionTeam(CompetitionTeam team) {
    final jumpersJson = team.jumpers.map((jumper) => idsRepo.idOf(jumper)).toList();
    return {
      'type': 'competition_team',
      'parentTeam': serialize(team),
      'jumpers': jumpersJson,
    };
  }

  Json _serializeSubteam(Subteam team) {
    final jumpersJson = team.jumpers.map((jumper) => idsRepo.idOf(jumper)).toList();
    return {
      'type': 'subteam',
      'parentTeam': serialize(team),
      'jumpers': jumpersJson,
      'label': team.label,
    };
  }
}
