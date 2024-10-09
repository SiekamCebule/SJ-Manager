import 'dart:async';

import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/standings/score/score.dart';
import 'package:sj_manager/models/simulation/standings/standings.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/database_io.dart';

class StandingsSerializer implements SimulationDbPartSerializer<Standings> {
  const StandingsSerializer({
    required this.idsRepo,
    required this.scoreSerializer,
    required this.positionsCreatorSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<Score> scoreSerializer;
  final StandingsPositionsCreatorSerializer positionsCreatorSerializer;

  @override
  FutureOr<Json> serialize(Standings standings) async {
    final scoresJson = await serializeItemsMap(
      items: standings.scores,
      idsRepo: idsRepo,
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
