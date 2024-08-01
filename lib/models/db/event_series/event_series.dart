import 'package:json_annotation/json_annotation.dart';
import 'package:sj_manager/models/db/event_series/event_series_calendar.dart';
import 'package:sj_manager/models/db/event_series/event_series_facts.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

@JsonSerializable()
class EventSeries {
  const EventSeries({
    required this.id,
    required this.name,
    required this.calendar,
    required this.facts,
  });

  final String id;
  final MultilingualString name;
  final EventSeriesCalendar calendar;
  final EventSeriesFacts facts;

  DateTime get startDate => calendar.competitions.first.date;
  DateTime get endDate => calendar.competitions.last.date;
}
