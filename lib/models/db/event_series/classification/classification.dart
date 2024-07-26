import 'package:sj_manager/models/db/event_series/classification/classification_scoring_delegate.dart';
import 'package:sj_manager/models/db/event_series/classification/classification_standings_repo.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class Classification<T> {
  const Classification({
    required this.name,
    required this.competitions,
    required this.standings,
    required this.scoringDelegate,
  });

  final String name;
  final ItemsRepo<Competition> competitions;
  final ClassificationStandingsRepo<T> standings;
  final ClassificationScoringDelegate scoringDelegate; // TODO: embrace type parameters
}
