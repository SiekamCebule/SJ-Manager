import 'package:sj_manager/bloc/simulation_db_loading/simulation_db_part_loader.dart';
import 'package:sj_manager/bloc/simulation_db_loading/standings_loader.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/db/country/country.dart';
import 'package:sj_manager/models/db/event_series/classification/classification.dart';
import 'package:sj_manager/models/db/event_series/competition/rules/user_algorithms/concrete/classification_score_creator.dart';
import 'package:sj_manager/repositories/generic/ids_repo.dart';
import 'package:sj_manager/utils/id_generator.dart';

class ClassificationLoader implements SimulationDbPartLoader<Classification> {
  const ClassificationLoader({
    required this.idsRepo,
    required this.idGenerator,
    required this.languageCode,
    required this.scoringDelegateLoader,
  });

  final IdsRepo idsRepo;
  final IdGenerator idGenerator;
  final String languageCode;
  final SimulationDbPartLoader<ClassificationScoreCreator> scoringDelegateLoader;

  @override
  Classification load(Json json) {
    final name = stringFromMultilingualJson(json,
        languageCode: languageCode, parameterName: 'name');
    final standings = StandingsLoader(idsRepo: idsRepo, idGenerator: idGenerator).load(
      json['standings'],
    );
    final scoreCreator = idsRepo.get<ClassificationScoreCreator>(json['scoreCreatorId']);
    return Classification(
      name: name,
      standings: standings,
      scoreCreator: scoreCreator,
    );
  }
}
