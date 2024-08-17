import 'package:flutter/material.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class EventSeriesSetup {
  const EventSeriesSetup({
    required this.id,
    required this.multilingualName,
    required this.priority,
    this.calendarPreset,
  });

  const EventSeriesSetup.empty()
      : this(
          id: '',
          multilingualName: const MultilingualString(namesByLanguage: {}),
          priority: 1,
        );

  final String id;
  final MultilingualString multilingualName;
  final int priority;
  final EventSeriesCalendarPreset? calendarPreset;

  String name(BuildContext context) {
    return multilingualName.translate(context);
  }
}
