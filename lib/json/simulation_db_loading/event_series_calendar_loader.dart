import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/competition.dart';
import 'package:sj_manager/models/simulation_db/event_series/event_series_calendar.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class EventSeriesCalendarLoader implements SimulationDbPartLoader<EventSeriesCalendar> {
  const EventSeriesCalendarLoader({
    required this.idsRepo,
    required this.idGenerator,
    required this.competitionLoader,
    required this.classificationLoader,
  });

  final IdsRepo idsRepo;
  final IdGenerator idGenerator;
  final SimulationDbPartLoader<Competition> competitionLoader;
  final SimulationDbPartLoader<Classification> classificationLoader;

  @override
  EventSeriesCalendar load(Json json) {
    final competitionsJson = json['competitions'] as List<Json>;
    final competitions = competitionsJson.map((json) {
      final competition = competitionLoader.load(json);
      idsRepo.register(competition, id: idGenerator.generate());
      return competition;
    });
    final classificationsJson = json['classifications'] as List<Json>;
    final classifications = classificationsJson.map((json) {
      final classification = classificationLoader.load(json);
      idsRepo.register(classification, id: idGenerator.generate());
      return classification;
    });
    final qualificationsJson = json['qualifications'] as Json;
    final qualifications = qualificationsJson.map((competitionId, qualifiactionsId) {
      return MapEntry(idsRepo.get<Competition>(competitionId),
          idsRepo.get<Competition>(qualifiactionsId));
    });
    return EventSeriesCalendar(
      competitions: competitions.toList(),
      classifications: classifications.toList(),
      qualifications: qualifications,
    );
  }
}
