import 'package:json_annotation/json_annotation.dart';

part 'event_series_facts.g.dart';

@JsonSerializable()
class EventSeriesFacts {
  const EventSeriesFacts({
    required this.priority,
  });

  final int priority;
}
