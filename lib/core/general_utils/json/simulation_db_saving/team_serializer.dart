import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/json/utils/enums.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/competition_team.dart';
import 'package:sj_manager/core/core_classes/country_team/country_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class TeamSerializer implements SimulationDbPartSerializer<Team> {
  const TeamSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

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
    final jumpersJson = team.jumpers.map((jumper) => idsRepository.id(jumper)).toList();
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
