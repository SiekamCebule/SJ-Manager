import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/specific_teams/competition_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionTeamSerializer implements SimulationDbPartSerializer<CompetitionTeam> {
  const CompetitionTeamSerializer({
    required this.idsRepository,
    required this.teamSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<SimulationTeam> teamSerializer;

  @override
  Json serialize(CompetitionTeam team) {
    return {
      'parentTeam': teamSerializer.serialize(team.parentTeam),
      'jumpers': team.jumpers.map(idsRepository.id).toList(),
    };
  }
}
