import 'package:flutter_test/flutter_test.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_positions_map_creator/standings_positions_with_no_ex_aequo_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';

void main() {
  group(StandingsRepo, () {
    late StandingsRepo standings;
    setUp(() {
      standings =
          StandingsRepo(positionsCreator: StandingsPositionsWithNoExAequoCreator());
    });
  });
}
