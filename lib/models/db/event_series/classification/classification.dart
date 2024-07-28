import 'package:sj_manager/models/db/event_series/classification/classification_scoring_delegate/classification_scoring_delegate.dart';
import 'package:sj_manager/models/db/event_series/standings/score/score.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_record.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class Classification<E, S extends Score, R extends StandingsRecord<E, S>> {
  const Classification({
    required this.name,
    required this.competitions,
    required this.standings,
    required this.scoringDelegate,
  });

  final String name;
  final ItemsRepo<Competition> competitions;
  final StandingsRepo<E, S, R> standings;
  final ClassificationScoringDelegate scoringDelegate; // TODO: embrace type parameters
}
