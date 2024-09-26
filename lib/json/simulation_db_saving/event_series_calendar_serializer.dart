import 'dart:async';

import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class EventSeriesCalendarSerializer
    implements SimulationDbPartSerializer<EventSeriesCalendar> {
  const EventSeriesCalendarSerializer({
    required this.idsRepo,
    required this.competitionSerializer,
    required this.classificationSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<Competition> competitionSerializer;
  final SimulationDbPartSerializer<Classification> classificationSerializer;

  @override
  Future<Json> serialize(EventSeriesCalendar calendar) async {
    final competitionsJsonFutures = calendar.competitions.map((competition) async {
      return await _serializeCompetition(competition);
    }).toList();

    final classificationsJsonFutures =
        calendar.classifications.map((classification) async {
      return await _serializeClassification(classification);
    }).toList();

    final qualificationsJsonFutures = calendar.qualifications.entries.map((entry) async {
      return await _serializeQualification(MapEntry(entry.key, entry.value));
    }).toList();

    final competitionsJson = await Future.wait(competitionsJsonFutures);
    final classificationsJson = await Future.wait(classificationsJsonFutures);
    final qualificationsJson = await Future.wait(qualificationsJsonFutures);

    return {
      'competitions': competitionsJson,
      'classifications': classificationsJson,
      'qualifications': Map.fromEntries(qualificationsJson),
    };
  }

  FutureOr<Map<String, dynamic>> _serializeCompetition(Competition competition) async {
    return await competitionSerializer.serialize(competition);
  }

  FutureOr<Map<String, dynamic>> _serializeClassification(
      Classification classification) async {
    return await classificationSerializer.serialize(classification);
  }

  FutureOr<MapEntry<Object, Object>> _serializeQualification(
      MapEntry<Competition, Competition> entry) async {
    return MapEntry(idsRepo.idOf(entry.key), idsRepo.idOf(entry.value));
  }
}
