import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class EventSeriesCalendarSerializer
    implements SimulationDbPartSerializer<EventSeriesCalendar> {
  const EventSeriesCalendarSerializer({
    required this.idsRepo,
    required this.competitionSerializer,
    required this.classificationSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<Competition> competitionSerializer;
  final SimulationDbPartSerializer<Classification> classificationSerializer;

  @override
  Json serialize(EventSeriesCalendar calendar) {
    final competitionsJson = calendar.competitions.map((competition) {
      return competitionSerializer.serialize(competition);
    }).toList();
    final classificationsJson = calendar.classifications.map((classification) {
      return classificationSerializer.serialize(classification);
    });
    final qualificationsJson = calendar.qualifications.map((competition, qualifications) {
      return MapEntry(idsRepo.idOf(competition), idsRepo.idOf(qualifications));
    });

    return {
      'competitions': competitionsJson,
      'classifications': classificationsJson,
      'qualifications': qualificationsJson,
    };
  }
}
