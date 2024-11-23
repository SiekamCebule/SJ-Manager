import 'dart:async';

import 'package:sj_manager/core/general_utils/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/core/general_utils/json/json_types.dart';
import 'package:sj_manager/to_embrace/classification/classification.dart';
import 'package:sj_manager/to_embrace/competition/competition.dart';
import 'package:sj_manager/features/simulations/domain/entities/simulation/database/calendar/event_series/event_series_calendar.dart';
import 'package:sj_manager/core/general_utils/ids_repository.dart';
import 'package:sj_manager/core/general_utils/database_io.dart';

class EventSeriesCalendarSerializer
    implements SimulationDbPartSerializer<EventSeriesCalendar> {
  const EventSeriesCalendarSerializer({
    required this.idsRepository,
    required this.competitionSerializer,
    required this.classificationSerializer,
  });

  final IdsRepository idsRepository;
  final SimulationDbPartSerializer<Competition> competitionSerializer;
  final SimulationDbPartSerializer<Classification> classificationSerializer;

  @override
  Future<Json> serialize(EventSeriesCalendar calendar) async {
    final competitionsJson = await serializeItemsMap(
      items: calendar.competitions,
      idsRepository: idsRepository,
      toJson: (competition) async => await _serializeCompetition(competition),
    );

    final classificationsJson = await serializeItemsMap(
      items: calendar.classifications,
      idsRepository: idsRepository,
      toJson: (competition) async => await _serializeClassification(competition),
    );

    final qualificationsJsonFutures = calendar.qualifications.entries.map((entry) async {
      return await _serializeQualification(MapEntry(entry.key, entry.value));
    }).toList();

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
    return MapEntry(idsRepository.id(entry.key), idsRepository.id(entry.value));
  }
}
