import 'package:sj_manager/models/db/event_series/classification/classification.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';
import 'package:sj_manager/repositories/generic/items_repo.dart';

class EventSeriesCalendar {
  const EventSeriesCalendar({
    required this.competitionsRepo,
    required this.classificationsRepo,
  });

  final ItemsRepo<Competition> competitionsRepo;
  final ItemsRepo<Classification> classificationsRepo;
}
