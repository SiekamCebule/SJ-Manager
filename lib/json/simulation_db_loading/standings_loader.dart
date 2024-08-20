import 'package:sj_manager/json/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class StandingsLoader<E, S extends Score> implements SimulationDbPartLoader<Standings> {
  const StandingsLoader({
    required this.idsRepo,
    required this.idGenerator,
    required this.scoreLoader,
    required this.positionsCreatorLoader,
  });

  final ItemsIdsRepo idsRepo;
  final IdGenerator idGenerator;
  final SimulationDbPartLoader<Score> scoreLoader;
  final StandingsPositionsCreatorLoader positionsCreatorLoader;

  @override
  Standings load(Json json) {
    final scoresJson = json['scores'] as List<Json>;
    final scores = scoresJson.map((json) {
      final score = ScoreLoader(idsRepo: idsRepo).load(json);
      idsRepo.register(score, id: idGenerator.generate());
      return score;
    }).toList();
    final positionsCreatorJson = json['positionsCreator'] as String;
    final positionsCreator = positionsCreatorLoader.load(positionsCreatorJson);

    return Standings(
      positionsCreator: positionsCreator,
      initialScores: scores,
    );
  }
}
