import 'package:sj_manager/models/db/event_series/event_series_assets.dart';
import 'package:sj_manager/models/db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/db/event_series/event_series_facts.dart';

class EventSeries {
  const EventSeries({
    required this.calendar,
    required this.facts,
    required this.assets,
  });
  final EventSeriesCalendar calendar;
  final EventSeriesFacts facts;
  final EventSeriesAssets assets;

  DateTime get startDate => throw UnimplementedError(); // TODO
}
