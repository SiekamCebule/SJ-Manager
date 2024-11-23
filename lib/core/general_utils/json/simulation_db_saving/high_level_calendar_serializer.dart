import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';
import 'package:sj_manager/to_embrace/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/to_embrace/competition/high_level_calendar.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';

class HighLevelCalendarSerializer
    implements
        SimulationDbPartSerializer<HighLevelCalendar<CalendarMainCompetitionRecord>> {
  const HighLevelCalendarSerializer({
    required this.idsRepository,
    required this.mainCompetitionRecordSerializer,
    required this.classificationSerializer,
  });

  final IdsRepository idsRepository;
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
