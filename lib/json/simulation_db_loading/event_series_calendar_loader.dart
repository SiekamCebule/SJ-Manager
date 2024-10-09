import 'dart:async';

import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation/classification/classification.dart';
import 'package:sj_manager/models/simulation/competition/competition.dart';
import 'package:sj_manager/models/simulation/event_series/event_series_calendar.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/database_io.dart';
import 'package:sj_manager/utils/id_generator.dart';

class EventSeriesCalendarParser implements SimulationDbPartParser<EventSeriesCalendar> {
  const EventSeriesCalendarParser({
    required this.idsRepo,
    required this.idGenerator,
    required this.competitionParser,
    required this.classificationParser,
  });

  final ItemsIdsRepo idsRepo;
  final IdGenerator idGenerator;
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
    idsRepo.registerFromLoadedItemsMap(competitionsMap);

    final classificationsMap = await parseItemsMap(
      json: json['classifications'],
      fromJson: (json) async {
        return await _parseClassification(json);
      },
    );
    final classifications = classificationsMap.getOrderedItems();
    idsRepo.registerFromLoadedItemsMap(classificationsMap);

    final qualificationsJson = json['qualifications'] as Json;
    final qualifications = qualificationsJson.map((competitionId, qualificationsId) {
      return MapEntry(
        idsRepo.get<Competition>(competitionId),
        idsRepo.get<Competition>(qualificationsId),
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
