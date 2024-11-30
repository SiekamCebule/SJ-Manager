import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/core/general_utils/json/utils/enums.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/country_team.dart';
import 'package:sj_manager/features/career_mode/subfeatures/subteams/domain/entities/subteam.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class TeamSerializer implements SimulationDbPartSerializer<SimulationTeam> {
  const TeamSerializer({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  Json serialize(SimulationTeam team) {
    if (team is CountryTeam) {
      return _serializeCountryTeam(team);
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
      'subteams': team.subteams.map((subteam) => serialize(team)),
    };
  }

  Json _serializeSubteam(Subteam team) {
    return {
      'type': 'subteam',
      'parentTeam': serialize(team),
      'subteamType': team.type.name,
      'jumperIds': team.jumpers.map((jumper) => idsRepository.id(jumper))
    };
  }
}
