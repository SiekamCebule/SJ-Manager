import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/bloc/simulation_db_saving/standings_positions_creator_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class StandingsSerializer implements SimulationDbPartSerializer<StandingsRepo> {
  const StandingsSerializer({
    required this.idsRepo,
    required this.scoreSerializer,
    required this.positionsCreatorSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<Score> scoreSerializer;
  final StandingsPositionsCreatorSerializer positionsCreatorSerializer;

  @override
  Json serialize(StandingsRepo standings) {
    final scoresJson = standings.scores.map((score) {});
    return {
      'scores': scoresJson,
      'positionsCreator': positionsCreatorSerializer.serialize(standings.positionsCreator)
    };
  }
}
