import 'package:sj_manager/models/db/event_series/competition/calendar_records/high_level_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/competition.dart';

abstract interface class LowLevelCalendarCreator<T extends HighLevelCompetitionRecord> {
  const LowLevelCalendarCreator();

  List<Competition> convert(List<T> records);
}
