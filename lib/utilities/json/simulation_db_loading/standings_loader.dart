import 'dart:async';

import 'package:sj_manager/utilities/json/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/utilities/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/standings/score/score.dart';
import 'package:sj_manager/domain/entities/simulation/standings/standings.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';
import 'package:sj_manager/utilities/utils/database_io.dart';
import 'package:sj_manager/utilities/utils/id_generator.dart';

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
  FutureOr<Standings> parse(Json json) async {
    final scoresMap = await parseItemsMap(
      json: json['scores'],
      fromJson: (json) {
        final score = ScoreParser(idsRepo: idsRepo).parse(json);
        idsRepo.register(score, id: idGenerator.generate());
        return score;
      },
    );
    final scores = scoresMap.getOrderedItems();
    idsRepo.registerFromLoadedItemsMap(scoresMap);

    final positionsCreatorJson = json['positionsCreator'] as String;
    final positionsCreator = positionsCreatorParser.parse(positionsCreatorJson);

    return Standings(
      positionsCreator: positionsCreator,
      initialScores: scores,
    );
  }
}
