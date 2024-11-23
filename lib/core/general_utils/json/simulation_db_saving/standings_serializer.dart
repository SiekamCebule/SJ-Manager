import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/score/score.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/standings/standings.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/database_io.dart';

class StandingsSerializer implements SimulationDbPartSerializer<Standings> {
  const StandingsSerializer({
    required this.idsRepository,
    required this.scoreSerializer,
    required this.positionsCreatorSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<Score> scoreSerializer;
  final StandingsPositionsCreatorSerializer positionsCreatorSerializer;

  @override
  FutureOr<Json> serialize(Standings standings) async {
    final scoresJson = await serializeItemsMap(
      items: standings.scores,
      idsRepository: idsRepository,
      toJson: (score) async {
        return await scoreSerializer.serialize(score);
      },
    );

    return {
      'scores': scoresJson,
      'positionsCreator': positionsCreatorSerializer.serialize(standings.positionsCreator)
    };
  }
}
