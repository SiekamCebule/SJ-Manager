import 'package:sj_manager/bloc/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class StandingsLoader<E, S extends Score>
    implements SimulationDbPartLoader<StandingsRepo> {
  const StandingsLoader({
    required this.idsRepo,
    required this.idGenerator,
  });

  final IdsRepo idsRepo;
  final IdGenerator idGenerator;

  @override
  StandingsRepo load(Json json) {
    final scoresJson = json['scores'] as List<Json>;
    final scores = scoresJson.map((json) {
      final score = ScoreLoader(idsRepo: idsRepo).load(json);
      idsRepo.register(score, id: idGenerator.generate());
      return score;
    }).toList();
    final positionsCreatorJson = json['positionsCreator'] as String;
    final positionsCreator =
        StandingsPositionsCreatorLoader(idsRepo: idsRepo).load(positionsCreatorJson);

    return StandingsRepo(
      positionsCreator: positionsCreator,
      initialScores: scores,
    );
  }
}
