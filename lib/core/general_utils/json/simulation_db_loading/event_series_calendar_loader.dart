import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_calendar.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/database_io.dart';

class EventSeriesCalendarParser implements SimulationDbPartParser<EventSeriesCalendar> {
  const EventSeriesCalendarParser({
    required this.idsRepository,
    required this.competitionParser,
    required this.classificationParser,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartParser<Competition> competitionParser;
  final SimulationDbPartParser<Classification> classificationParser;

  @override
  Future<EventSeriesCalendar> parse(Json json) async {
    final competitionsMap = await parseItemsMap(
      json: json['competitions'],
      fromJson: (json) async {
        return await _parseCompetition(json);
      },
    );
    final competitions = competitionsMap.getOrderedItems();
    idsRepository.registerFromLoadedItemsMap(competitionsMap);

    final classificationsMap = await parseItemsMap(
      json: json['classifications'],
      fromJson: (json) async {
        return await _parseClassification(json);
      },
    );
    final classifications = classificationsMap.getOrderedItems();
    idsRepository.registerFromLoadedItemsMap(classificationsMap);

    final qualificationsJson = json['qualifications'] as Json;
    final qualifications = qualificationsJson.map((competitionId, qualificationsId) {
      return MapEntry(
        idsRepository.get<Competition>(competitionId),
        idsRepository.get<Competition>(qualificationsId),
      );
    });

    return EventSeriesCalendar(
      competitions: competitions,
      classifications: classifications,
      qualifications: qualifications,
    );
  }

  FutureOr<Competition> _parseCompetition(Json json) async {
    final competition = await competitionParser.parse(json);
    return competition;
  }

  FutureOr<Classification> _parseClassification(Json json) async {
    final classification = await classificationParser.parse(json);
    return classification;
  }
}
