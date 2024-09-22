import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/models/simulation_db/competition/high_level_calendar.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class HighLevelCalendarParser
    implements SimulationDbPartParser<HighLevelCalendar<CalendarMainCompetitionRecord>> {
  const HighLevelCalendarParser({
    required this.idsRepo,
    required this.idGenerator,
    required this.mainCompetitionRecordParser,
    required this.classificationParser,
  });

  final ItemsIdsRepo idsRepo;
  final IdGenerator idGenerator;
  final SimulationDbPartParser<CalendarMainCompetitionRecord> mainCompetitionRecordParser;
  final SimulationDbPartParser<Classification> classificationParser;

  @override
  HighLevelCalendar<CalendarMainCompetitionRecord> parse(Json json) {
    final competitionsJson = (json['competitions'] as List).cast<Json>();
    final competitions = competitionsJson.map((json) {
      final competitionRecord = mainCompetitionRecordParser.parse(json);
      idsRepo.register(competitionRecord, id: idGenerator.generate());
      return competitionRecord;
    }).toList();
    final classificationsJson = (json['classifications'] as List).cast<Json>();
    final classifications = classificationsJson.map((json) {
      final classification = classificationParser.parse(json);
      idsRepo.register(classification, id: idGenerator.generate());
      return classification;
    }).toList();
    return HighLevelCalendar(
      highLevelCompetitions: competitions.toList(),
      classifications: classifications.toList(),
    );
  }
}
