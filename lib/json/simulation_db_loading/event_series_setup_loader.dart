import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_setup.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class EventSeriesSetupParser implements SimulationDbPartParser<EventSeriesSetup> {
  const EventSeriesSetupParser({
    required this.idsRepo,
  });

  final ItemsIdsRepo idsRepo;

  @override
  EventSeriesSetup parse(Json json) {
    final name = MultilingualString(valuesByLanguage: (json['name'] as Map).cast());
    final descriptionJson = json['description'] as Map?;
    final description = descriptionJson != null
        ? MultilingualString(valuesByLanguage: descriptionJson.cast())
        : null;
    final setup = EventSeriesSetup(
      id: json['id'],
      multilingualName: name,
      multilingualDescription: description,
      priority: json['priority'],
      relativeMoneyPrize: EventSeriesRelativeMoneyPrize.values
          .singleWhere((value) => value.name == json['relativeMoneyPrize']),
    );
    return setup;
  }
}
