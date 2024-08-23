import 'package:sj_manager/json/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/standings/score/score.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class StandingsParser<E, S extends Score> implements SimulationDbPartParser<Standings> {
  const StandingsParser({
    required this.idsRepo,
    required this.idGenerator,
    required this.scoreParser,
    required this.positionsCreatorParser,
  });

  final ItemsIdsRepo idsRepo;
  final IdGenerator idGenerator;
  final SimulationDbPartParser<Score> scoreParser;
  final StandingsPositionsCreatorParser positionsCreatorParser;

  @override
  Standings parse(Json json) {
    final scoresJson = json['scores'] as List<Json>;
    final scores = scoresJson.map((json) {
      final score = ScoreParser(idsRepo: idsRepo).parse(json);
      idsRepo.register(score, id: idGenerator.generate());
      return score;
    }).toList();
    final positionsCreatorJson = json['positionsCreator'] as String;
    final positionsCreator = positionsCreatorParser.parse(positionsCreatorJson);

    return Standings(
      positionsCreator: positionsCreator,
      initialScores: scores,
    );
  }
}
