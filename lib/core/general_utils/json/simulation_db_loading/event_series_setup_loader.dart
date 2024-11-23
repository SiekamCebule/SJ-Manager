import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_setup.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/multilingual_string.dart';

class EventSeriesSetupParser implements SimulationDbPartParser<EventSeriesSetup> {
  const EventSeriesSetupParser({
    required this.idsRepository,
  });

  final IdsRepository idsRepository;

  @override
  EventSeriesSetup parse(Json json) {
    final name = MultilingualString((json['name'] as Map).cast());
    final descriptionJson = json['description'] as Map?;
    final description =
        descriptionJson != null ? MultilingualString(descriptionJson.cast()) : null;
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
