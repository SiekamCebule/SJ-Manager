import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_setup.dart';

abstract base class EventSeriesImageAsset {
  const EventSeriesImageAsset({
    required this.eventSeriesSetup,
  });

  final EventSeriesSetup eventSeriesSetup;
}

final class EventSeriesLogoImageWrapper extends EventSeriesImageAsset {
  const EventSeriesLogoImageWrapper({required super.eventSeriesSetup});
}

final class EventSeriesTrophyImageWrapper extends EventSeriesImageAsset {
  const EventSeriesTrophyImageWrapper({required super.eventSeriesSetup});
}
