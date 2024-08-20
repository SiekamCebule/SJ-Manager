import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class EventSeriesSetupLoader implements SimulationDbPartLoader<EventSeriesSetup> {
  const EventSeriesSetupLoader({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  EventSeriesSetup load(Json json) {
    final name = MultilingualString(namesByLanguage: (json['name'] as Map).cast());
    final setup = EventSeriesSetup(
      id: json['id'],
      multilingualName: name,
      priority: json['priority'],
    );
    return setup;
  }
}
