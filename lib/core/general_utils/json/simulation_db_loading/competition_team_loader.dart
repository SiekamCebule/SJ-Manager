import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/jumper/simulation_jumper.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/team/simulation_team/simulation_team.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/subjects/competition_team.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class CompetitionTeamLoader implements SimulationDbPartParser<CompetitionTeam> {
  const CompetitionTeamLoader({
    required this.idsRepository,
    required this.simulationTeamLoader,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<SimulationTeam> simulationTeamLoader;

  @override
  FutureOr<CompetitionTeam> parse(Json json) async {
    final parentTeamJson = json['parentTeam'] as Json;
    final parentTeam = await simulationTeamLoader.parse(parentTeamJson);
    final jumperIds = json['jumperIds'] as List;
    final jumpers = jumperIds.map((id) {
      return idsRepository.get(id) as SimulationJumper;
    }).toList();

    return CompetitionTeam(
      parentTeam: parentTeam,
      jumpers: jumpers,
    );
  }
}
