import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/concrete/classification_score_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';

class Classification<E> {
  const Classification({
    required this.name,
    required this.standings,
    required this.scoreCreator,
  });

  final String name;
  final StandingsRepo<E> standings;
  final ClassificationScoreCreator scoreCreator;

  void updateStandings() {
    standings.update();
  }
}
