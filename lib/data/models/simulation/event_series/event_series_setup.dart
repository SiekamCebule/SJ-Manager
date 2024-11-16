import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sj_manager/data/models/simulation/event_series/event_series_calendar_preset.dart';
import 'package:sj_manager/utilities/utils/multilingual_string.dart';

class EventSeriesSetup with EquatableMixin {
  const EventSeriesSetup({
    required this.id,
    required this.multilingualName,
    required this.multilingualDescription,
    required this.priority,
    required this.relativeMoneyPrize,
    this.calendarPreset,
  });

  const EventSeriesSetup.empty()
      : this(
          id: '',
          multilingualName: const MultilingualString.empty(),
          multilingualDescription: const MultilingualString.empty(),
          priority: 1,
          relativeMoneyPrize: EventSeriesRelativeMoneyPrize.average,
        );

  final String id;
  final MultilingualString multilingualName;
  final MultilingualString? multilingualDescription;
  final int priority;
  final EventSeriesRelativeMoneyPrize relativeMoneyPrize;
  final EventSeriesCalendarPreset? calendarPreset;

  String name(BuildContext context) {
    return multilingualName.translate(context);
  }

  @override
  List<Object?> get props => [
        id,
        multilingualName,
        multilingualDescription,
        priority,
        relativeMoneyPrize,
        calendarPreset,
      ];
}

enum EventSeriesRelativeMoneyPrize {
  veryLow,
  low,
  average,
  high,
  veryHigh,
}
