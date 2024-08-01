import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_ex_aequos_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_no_ex_aequo_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_shuffle_on_equal_positions_creator.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class StandingsPositionsCreatorLoader
    implements SimulationDbPartLoader<StandingsPositionsCreator> {
  const StandingsPositionsCreatorLoader({
    required this.idsRepo,
  });

  final IdsRepo idsRepo;

  @override
  StandingsPositionsCreator<Score> load(dynamic json) {
    final type = json as String;
    return switch (type) {
      'with_ex_aequos' => StandingsPositionsWithExAequosCreator(),
      'with_no_ex_aequo' => StandingsPositionsWithNoExAequoCreator(),
      'with_shuffle_on_equal_positions' =>
        StandingsPositionsWithShuffleOnEqualPositionsCreator(),
      _ => throw ArgumentError('Invalid StandingsPositionCreator type: $type'),
    };
  }
}
