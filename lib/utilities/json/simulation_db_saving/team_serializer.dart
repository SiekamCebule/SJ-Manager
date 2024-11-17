import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/utilities/json/utils/enums.dart';
import 'package:sj_manager/domain/entities/simulation/team/competition_team.dart';
import 'package:sj_manager/core/team/country_team/country_team.dart';
import 'package:sj_manager/domain/entities/simulation/team/subteam.dart';
import 'package:sj_manager/domain/entities/simulation/team/team.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

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
    final subteamsJson =
        team.facts.subteams.map((subteamType) => subteamType.name).toList();
    return {
      'type': 'country_team',
      'sex': sexEnumMap[team.sex],
      'countryCode': team.country.code,
      'facts': {
        'subteams': subteamsJson,
        'stars': team.facts.stars,
        'record': team.facts.record != null
            ? {
                'jumperNameAndSurname': team.facts.record!.jumperNameAndSurname,
                'distance': team.facts.record!.distance,
              }
            : null,
        'limitInSubteam': team.facts.limitInSubteam.map(
          (subteamType, limit) => MapEntry(
            subteamType.name,
            limit,
          ),
        ),
      },
    };
  }

  Json _serializeCompetitionTeam(CompetitionTeam team) {
    final jumpersJson = team.jumpers.map((jumper) => idsRepo.id(jumper)).toList();
    return {
      'type': 'competition_team',
      'parentTeam': serialize(team),
      'jumpers': jumpersJson,
    };
  }

  Json _serializeSubteam(Subteam team) {
    return {
      'type': 'subteam',
      'parentTeam': serialize(team),
      'subteamType': team.type.name,
    };
  }
}
