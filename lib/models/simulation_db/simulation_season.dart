import 'package:equatable/equatable.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series.dart';

class SimulationSeason with EquatableMixin {
  const SimulationSeason({
    required this.eventSeries,
  });

  final List<EventSeries> eventSeries;

  // TODO:
  DateTime get startDate {
    throw UnimplementedError();
  }

  DateTime get endDate {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [];
}
