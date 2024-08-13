import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class EventSeries {
  const EventSeries({
    required this.calendar,
    required this.setup,
  });

  const EventSeries.empty()
      : this(
          calendar: const EventSeriesCalendar.empty(),
          setup: const EventSeriesSetup(
            id: '',
            name: MultilingualString(namesByLanguage: {}),
            priority: 0,
          ),
        );

  final EventSeriesCalendar calendar;
  final EventSeriesSetup setup;

  DateTime get startDate => calendar.competitions.first.date;
  DateTime get endDate => calendar.competitions.last.date;
}
