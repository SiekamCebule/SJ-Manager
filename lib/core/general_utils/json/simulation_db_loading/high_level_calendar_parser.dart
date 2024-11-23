import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';
import 'package:sj_manager/to_embrace/competition/calendar_records/calendar_main_competition_record.dart';
import 'package:sj_manager/to_embrace/competition/high_level_calendar.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/id_generator.dart';

class HighLevelCalendarParser
    implements SimulationDbPartParser<HighLevelCalendar<CalendarMainCompetitionRecord>> {
  const HighLevelCalendarParser({
    required this.idsRepository,
    required this.idGenerator,
    required this.mainCompetitionRecordParser,
    required this.classificationParser,
  });

  final IdsRepository idsRepository;
  final IdGenerator idGenerator;
  final SimulationDbPartParser<CalendarMainCompetitionRecord> mainCompetitionRecordParser;
  final SimulationDbPartParser<Classification> classificationParser;

  @override
  Future<HighLevelCalendar<CalendarMainCompetitionRecord>> parse(Json json) async {
    final competitionsJson = (json['competitions'] as List).cast<Json>();
    final competitionsFutures = competitionsJson.map((json) {
      return compute(_parseCompetitionRecord, json);
    }).toList();

    final classificationsJson = (json['classifications'] as List).cast<Json>();
    final classificationsFutures = classificationsJson.map((json) {
      return compute(_parseClassification, json);
    }).toList();

    final competitions = await Future.wait(competitionsFutures);
    final classifications = await Future.wait(classificationsFutures);

    return HighLevelCalendar(
      highLevelCompetitions: competitions,
      classifications: classifications,
    );
  }

  FutureOr<CalendarMainCompetitionRecord> _parseCompetitionRecord(Json json) async {
    final competitionRecord = await mainCompetitionRecordParser.parse(json);
    idsRepository.register(competitionRecord, id: idGenerator.generate());
    return competitionRecord;
  }

  FutureOr<Classification> _parseClassification(Json json) async {
    final classification = await classificationParser.parse(json);
    idsRepository.register(classification, id: idGenerator.generate());
    return classification;
  }
}
