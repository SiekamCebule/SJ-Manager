import 'package:sj_manager/json/simulation_db_saving/simulation_db_part_serializer.dart';
import 'package:sj_manager/json/json_types.dart';
import 'package:sj_manager/models/simulation_db/classification/classification.dart';
import 'package:sj_manager/models/simulation_db/classification/default_classification_rules.dart';
import 'package:sj_manager/models/simulation_db/standings/standings.dart';
import 'package:sj_manager/repositories/generic/items_ids_repo.dart';

class ClassificationSerializer implements SimulationDbPartSerializer<Classification> {
  const ClassificationSerializer({
    required this.idsRepo,
    required this.standingsSerializer,
    required this.defaultClassificationRulesSerializer,
  });

  final ItemsIdsRepo idsRepo;
  final SimulationDbPartSerializer<Standings> standingsSerializer;
  final SimulationDbPartSerializer<DefaultClassificationRules>
      defaultClassificationRulesSerializer;

  @override
  Json serialize(Classification classification) {
    if (classification is DefaultClassification) {
      return _serializeDefault(classification);
    } else {
      throw UnsupportedError(
        '(Serializing) An unsupported classification type (${classification.runtimeType})',
      );
    }
  }

  Json _serializeDefault(DefaultClassification classification) {
    return {
      'name': classification.name,
      'standings': classification.standings != null
          ? standingsSerializer.serialize(classification.standings!)
          : null,
      'rules': defaultClassificationRulesSerializer.serialize(classification.rules),
    };
  }
}
