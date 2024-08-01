import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/concrete/classification_score_creator.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class Classification<E> {
  const Classification({
    required this.name,
    required this.standings,
    required this.scoreCreator,
  });

  final MultilingualString name;
  final StandingsRepo<E>? standings;
  final ClassificationScoreCreator scoreCreator;

  void updateStandings() {
    if (standings == null) {
      throw StateError('Standings are null, so cannot update them');
    }
    standings!.update();
  }
}
