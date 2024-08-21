import 'package:sj_manager/json/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/competition/rules/user_algorithms/concrete/classification_score_creator.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';
import 'package:sj_manager/utils/multilingual_string.dart';

class ClassificationLoader implements SimulationDbPartLoader<Classification> {
  const ClassificationLoader({
    required this.idsRepo,
    required this.standingsLoader,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartLoader<Standings> standingsLoader;

  @override
  Classification load(Json json) {
    final standings = standingsLoader.load(json['standings']);
    final scoreCreator = idsRepo.get<ClassificationScoreCreator>(json['scoreCreatorId']);
    return Classification(
      name: MultilingualString(namesByLanguage: json['name']),
      standings: standings,
      scoreCreator: scoreCreator,
    );
  }
}
