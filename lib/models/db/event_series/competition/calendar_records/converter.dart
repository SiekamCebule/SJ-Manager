import 'package:sj_manager/models/db/event_series/competition/calendar_records/high_level_competition_record.dart';
import 'package:sj_manager/models/db/event_series/competition/high_level_calendar.dart';
import 'package:sj_manager/models/db/event_series/event_series_calendar.dart';

abstract interface class LowLevelCalendarCreator<C extends HighLevelCompetitionRecord> {
  const LowLevelCalendarCreator();

  EventSeriesCalendar convert(HighLevelCalendar<C> highLevelCalendar);
}
