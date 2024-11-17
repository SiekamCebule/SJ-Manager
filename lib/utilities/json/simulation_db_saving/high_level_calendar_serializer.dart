import 'package:sj_manager/utilities/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/utilities/json/json_types.dart';
import 'package:sj_manager/domain/entities/simulation/classification/classification.dart';
import 'package:sj_manager/domain/entities/simulation/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/domain/entities/simulation/competition/high_level_calendar.dart';
import 'package:sj_manager/domain/repository_interfaces/generic/items_ids_repo.dart';

class HighLevelCalendarSerializer
    implements
        SimulationDbPartSerializer<HighLevelCalendar<CalendarMainCompetitionRecord>> {
  const HighLevelCalendarSerializer({
    required this.idsRepo,
    required this.mainCompetitionRecordSerializer,
    required this.classificationSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<CalendarMainCompetitionRecord>
      mainCompetitionRecordSerializer;
  final SimulationDbPartSerializer<Classification> classificationSerializer;

  @override
  Json serialize(HighLevelCalendar<CalendarMainCompetitionRecord> record) {
    return {
      'competitions': record.highLevelCompetitions
          .map(mainCompetitionRecordSerializer.serialize)
          .toList(),
      'classifications':
          record.classifications.map(classificationSerializer.serialize).toList(),
    };
  }
}
