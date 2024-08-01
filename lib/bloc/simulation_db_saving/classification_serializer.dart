import 'package:sj_manager/bloc/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/event_series/classification/classification.dart';
import 'package:sj_manager/models/db/event_series/standings/standings_repo.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';

class ClassificationSerializer implements SimulationDbPartSerializer<Classification> {
  const ClassificationSerializer({
    required this.idsRepo,
    required this.standingsSerializer,
  });

  final IdsRepo idsRepo;
  final SimulationDbPartSerializer<StandingsRepo> standingsSerializer;

  @override
  Json serialize(Classification classification) {
    return {
      'name': classification.name.namesByLanguage,
      'scoreCreatorId': idsRepo.idOf(classification.scoreCreator),
      if (classification.standings != null)
        'standings': standingsSerializer.serialize(classification.standings!),
      if (classification.standings == null) 'standings': null,
    };
  }
}
