import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/score_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/standings_positions_creator_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/score/score.dart';
import 'package:sj_manager/features/competitions/domain/entities/scoring/standings.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/database_io.dart';

class StandingsParser implements SimulationDbPartParser<Standings> {
  const StandingsParser({
    required this.idsRepository,
    required this.scoreParser,
    required this.positionsCreatorParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<Score> scoreParser;
  final StandingsPositionsCreatorParser positionsCreatorParser;

  @override
  FutureOr<Standings> parse(Json json) async {
    final scoresMap = await parseItemsMap(
      json: json['scores'],
      fromJson: (json) {
        final score = ScoreParser(idsRepository: idsRepository).parse(json);
        return score;
      },
    );
    final scores = scoresMap.getOrderedItems();
    idsRepository.registerFromLoadedItemsMap(scoresMap);

    final positionsCreatorJson = json['positionsCreator'] as String;
    final positionsCreator = positionsCreatorParser.parse(positionsCreatorJson);

    return Standings(
      positionsCreator: positionsCreator,
      initialScores: scores,
    );
  }
}
